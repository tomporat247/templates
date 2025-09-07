output "namespace_name" {
  description = "Name of the created namespace"
  value       = kubernetes_namespace.test_namespace.metadata[0].name
}

output "deployment_name" {
  description = "Name of the created deployment"
  value       = kubernetes_manifest.no_resource_limits.manifest.metadata.name
}

output "deployment_uid" {
  description = "UID of the created deployment"
  value       = kubernetes_manifest.no_resource_limits.object.metadata.uid
}

output "deployment_generation" {
  description = "Generation of the deployment"
  value       = kubernetes_manifest.no_resource_limits.object.metadata.generation
}

output "deployment_labels" {
  description = "Labels applied to the deployment"
  value       = kubernetes_manifest.no_resource_limits.manifest.metadata.labels
}

output "replica_count" {
  description = "Number of replicas configured"
  value       = kubernetes_manifest.no_resource_limits.manifest.spec.replicas
}

output "container_names" {
  description = "Names of containers in the deployment"
  value       = [for container in kubernetes_manifest.no_resource_limits.manifest.spec.template.spec.containers : container.name]
}

output "container_images" {
  description = "Images used by containers in the deployment"
  value       = [for container in kubernetes_manifest.no_resource_limits.manifest.spec.template.spec.containers : container.image]
}
