
locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "mysql"
        image = var.image
        env = concat([
          {
            name  = "MYSQL_USER"
            value = var.MYSQL_USER
          },
          {
            name  = "MYSQL_PASSWORD"
            value = var.MYSQL_PASSWORD
          },
          {
            name  = "MYSQL_DATABASE"
            value = var.MYSQL_DATABASE
          },
          {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.MYSQL_ROOT_PASSWORD
          },
          {
            name  = "TZ"
            value = "UTC"
          },
        ], var.env)

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/var/lib/mysql"
            sub_path   = var.name
          },
        ]
      },
    ]
    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
