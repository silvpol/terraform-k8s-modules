resource "k8s_config_istio_io_v1alpha2_kubernetes" "attributes" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "attributes"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "attribute_bindings": {
        "destination.container.name": "$out.destination_container_name | \"unknown\"",
        "destination.ip": "$out.destination_pod_ip | ip(\"0.0.0.0\")",
        "destination.labels": "$out.destination_labels | emptyStringMap()",
        "destination.name": "$out.destination_pod_name | \"unknown\"",
        "destination.namespace": "$out.destination_namespace | \"default\"",
        "destination.owner": "$out.destination_owner | \"unknown\"",
        "destination.serviceAccount": "$out.destination_service_account_name | \"unknown\"",
        "destination.uid": "$out.destination_pod_uid | \"unknown\"",
        "destination.workload.name": "$out.destination_workload_name | \"unknown\"",
        "destination.workload.namespace": "$out.destination_workload_namespace | \"unknown\"",
        "destination.workload.uid": "$out.destination_workload_uid | \"unknown\"",
        "source.ip": "$out.source_pod_ip | ip(\"0.0.0.0\")",
        "source.labels": "$out.source_labels | emptyStringMap()",
        "source.name": "$out.source_pod_name | \"unknown\"",
        "source.namespace": "$out.source_namespace | \"default\"",
        "source.owner": "$out.source_owner | \"unknown\"",
        "source.serviceAccount": "$out.source_service_account_name | \"unknown\"",
        "source.uid": "$out.source_pod_uid | \"unknown\"",
        "source.workload.name": "$out.source_workload_name | \"unknown\"",
        "source.workload.namespace": "$out.source_workload_namespace | \"unknown\"",
        "source.workload.uid": "$out.source_workload_uid | \"unknown\""
      },
      "destination_port": "destination.port | 0",
      "destination_uid": "destination.uid | \"\"",
      "source_ip": "source.ip | ip(\"0.0.0.0\")",
      "source_uid": "source.uid | \"\""
    }
    JSON
}