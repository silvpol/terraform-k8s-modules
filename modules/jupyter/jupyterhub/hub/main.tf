/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports = [
      {
        name = "http"
        port = var.port
      }
    ]
    enable_service_links = false

    containers = [
      {
        command = [
          "jupyterhub",
          "--config",
          "/srv/jupyterhub_config.py",
        ]

        env = [
          {
            name  = "HUB_SERVICE_HOST"
            value = var.name
          },
          {
            name  = "HUB_SERVICE_PORT"
            value = var.port
          },
          {
            name  = "PROXY_API_SERVICE_HOST"
            value = var.proxy_api_service_host
          },
          {
            name  = "PROXY_API_SERVICE_PORT"
            value = var.proxy_api_service_port
          },
          {
            name  = "PROXY_PUBLIC_SERVICE_HOST"
            value = var.proxy_public_service_host
          },
          {
            name  = "PROXY_PUBLIC_SERVICE_PORT"
            value = var.proxy_public_service_port
          },
          {
            name  = "PYTHONUNBUFFERED"
            value = "1"
          },
          {
            name = "JPY_COOKIE_SECRET"
            value_from = {
              secret_key_ref = {
                key  = "hub.cookie-secret"
                name = var.secret_name
              }
            }
          },
          {
            name = "POD_NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name = "CONFIGPROXY_AUTH_TOKEN"
            value_from = {
              secret_key_ref = {
                key  = "proxy.token"
                name = var.secret_name
              }
            }
          },
          {
            name = "OAUTH2_AUTHORIZE_URL"
            value = var.OAUTH2_AUTHORIZE_URL
          },
          {
            name = "OAUTH2_TOKEN_URL"
            value = var.OAUTH2_TOKEN_URL
          },
          {
            name = "OAUTH_CALLBACK_URL"
            value = var.OAUTH_CALLBACK_URL
          },
        ]

        image = var.image
        name  = "jupyterhub"

        lifecycle = {
          post_start = {
            exec = {
              command = [
                "bash",
                "-cx",
                <<-EOF
                sed -i -e 's|key=lambda x: x.last_timestamp,|key=lambda x: x.last_timestamp and x.last_timestamp.timestamp() or 0.,|' /usr/local/lib/python3.6/dist-packages/kubespawner/spawner.py
                EOF
              ]
            }
          }
        }

        resources = {
          requests = {
            "cpu"    = "200m"
            "memory" = "512Mi"
          }
        }

        volume_mounts = [
          {
            mount_path = "/etc/jupyterhub/config/"
            name       = "config"
          },
          {
            mount_path = "/etc/jupyterhub/secret/"
            name       = "secret"
          }
        ]
      }
    ]
    security_context = {
      fsgroup    = 1000
      run_asuser = 0
    }
    service_account_name = module.rbac.service_account.metadata.0.name

    volumes = [
      {
        config_map = {
          name = var.config_map
        }
        name = "config"
      },
      {
        name = "secret"
        secret = {
          secret_name = var.secret_name
        }
      },
    ]
  }
}

module "rbac" {
  source    = "../../../kubernetes/rbac"
  name      = var.name
  namespace = var.namespace
  role_rules = [
    {
      api_groups = [
        "",
      ]
      resources = [
        "pods",
        "persistentvolumeclaims",
      ]
      verbs = [
        "get",
        "watch",
        "list",
        "create",
        "delete",
      ]
    },
    {
      api_groups = [
        "",
      ]
      resources = [
        "events",
      ]
      verbs = [
        "get",
        "watch",
        "list",
      ]
    }
  ]
}


module "deployment-service" {
  source     = "../../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}

