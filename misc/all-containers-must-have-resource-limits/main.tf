terraform {
  required_version = ">= 0.14"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

resource "kubernetes_namespace" "test_namespace" {
  metadata {
    name = var.namespace_name
    labels = var.namespace_labels
  }
}

resource "kubernetes_manifest" "no_resource_limits" {
  manifest = yamldecode(templatefile("${path.module}/deployment.yaml.tftpl", {
    deployment_name    = var.deployment_name
    namespace_name     = kubernetes_namespace.test_namespace.metadata[0].name
    deployment_labels  = var.deployment_labels
    replica_count      = var.replica_count
    app_name          = var.app_name
    container_name    = var.container_name
    container_image   = var.container_image
    container_port    = var.container_port
    environment       = var.environment
    app_version       = var.app_version
    health_check_path = var.health_check_path
    sidecar_image     = var.sidecar_image
    sidecar_port      = var.sidecar_port
    add_resource_limits = var.add_resource_limits
  }))
}
