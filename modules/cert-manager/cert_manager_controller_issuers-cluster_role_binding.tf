resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding" "cert_manager_controller_issuers" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.12.0"
    }
    name = "cert-manager-controller-issuers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager-controller-issuers"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = var.namespace
  }
}