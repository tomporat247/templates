output "namespace_name" {
  description = "Name of the created namespace"
  value       = kubernetes_namespace.test_namespace.metadata[0].name
}

output "deployment_name" {
  description = "Name of the created deployment"
  value       = kubernetes_manifest.registry_test_deployment.manifest.metadata.name
}

output "deployment_uid" {
  description = "UID of the created deployment"
  value       = kubernetes_manifest.registry_test_deployment.object.metadata.uid
}

output "deployment_annotations" {
  description = "Annotations on the deployment showing registry information"
  value       = kubernetes_manifest.registry_test_deployment.manifest.metadata.annotations
}

output "registry_type_used" {
  description = "Type of registry used (authorized or unauthorized)"
  value       = var.use_authorized_registry ? "authorized" : "unauthorized"
}

output "container_images" {
  description = "All container images used in the deployment"
  value = {
    web_server = local.selected_images.web_server
    sidecar    = local.selected_images.sidecar
    init       = local.selected_images.init
  }
}

output "registry_sources" {
  description = "Registry sources for all images"
  value = {
    web_server_registry = split("/", local.selected_images.web_server)[0]
    sidecar_registry    = split("/", local.selected_images.sidecar)[0]
    init_registry       = split("/", local.selected_images.init)[0]
  }
}

output "policy_test_info" {
  description = "Information for policy validation testing"
  value = {
    should_be_blocked = !var.use_authorized_registry
    registry_type     = var.use_authorized_registry ? "authorized" : "unauthorized"
    test_scenario     = var.use_authorized_registry ? "This deployment should be ALLOWED by registry policies" : "This deployment should be BLOCKED by registry policies"
  }
}

output "replica_count" {
  description = "Number of replicas configured"
  value       = kubernetes_manifest.registry_test_deployment.manifest.spec.replicas
}

output "container_names" {
  description = "Names of all containers in the deployment"
  value = {
    main_containers = [for container in kubernetes_manifest.registry_test_deployment.manifest.spec.template.spec.containers : container.name]
    init_containers = [for container in kubernetes_manifest.registry_test_deployment.manifest.spec.template.spec.initContainers : container.name]
  }
}
