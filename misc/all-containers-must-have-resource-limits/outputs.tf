output "namespace_name" {
  description = "Name of the created namespace"
  value       = kubernetes_namespace.test_namespace.metadata[0].name
}

output "deployment_name" {
  description = "Name of the created deployment"
  value       = kubernetes_deployment.no_resource_limits.metadata[0].name
}

output "deployment_uid" {
  description = "UID of the created deployment"
  value       = kubernetes_deployment.no_resource_limits.metadata[0].uid
}

output "deployment_generation" {
  description = "Generation of the deployment"
  value       = kubernetes_deployment.no_resource_limits.metadata[0].generation
}

output "deployment_labels" {
  description = "Labels applied to the deployment"
  value       = kubernetes_deployment.no_resource_limits.metadata[0].labels
}

output "replica_count" {
  description = "Number of replicas configured"
  value       = kubernetes_deployment.no_resource_limits.spec[0].replicas
}

output "container_names" {
  description = "Names of containers in the deployment"
  value       = [for container in kubernetes_deployment.no_resource_limits.spec[0].template[0].spec[0].container : container.name]
}

output "container_images" {
  description = "Images used by containers in the deployment"
  value       = [for container in kubernetes_deployment.no_resource_limits.spec[0].template[0].spec[0].container : container.image]
}
