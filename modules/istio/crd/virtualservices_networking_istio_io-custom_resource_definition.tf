resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "virtualservices_networking_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-pilot"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "virtualservices.networking.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.gateways"
      description = "The names of gateways and sidecars that should apply these routes"
      name        = "Gateways"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.hosts"
      description = "The destination hosts to which traffic is being sent"
      name        = "Hosts"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = <<-EOF
        CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
        
        Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata
        EOF
      name        = "Age"
      type        = "date"
    }
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind      = "VirtualService"
      list_kind = "VirtualServiceList"
      plural    = "virtualservices"
      short_names = [
        "vs",
      ]
      singular = "virtualservice"
    }
    scope   = "Namespaced"
    version = "v1alpha3"
  }
}