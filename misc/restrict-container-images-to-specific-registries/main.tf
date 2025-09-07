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

locals {
  unauthorized_images = {
    web_server = "${var.unauthorized_registry_base}/nginx:${var.image_tag}"
    sidecar    = "${var.unauthorized_registry_base}/busybox:${var.sidecar_tag}"
    init       = "${var.unauthorized_init_registry}/alpine:${var.init_tag}"
  }
  
  authorized_images = {
    web_server = "${var.authorized_registry_base}/nginx:${var.image_tag}"
    sidecar    = "${var.authorized_registry_base}/busybox:${var.sidecar_tag}"
    init       = "${var.authorized_registry_base}/alpine:${var.init_tag}"
  }
  
  selected_images = var.use_authorized_registry ? local.authorized_images : local.unauthorized_images
}

resource "kubernetes_namespace" "test_namespace" {
  metadata {
    name = var.namespace_name
    labels = var.namespace_labels
  }
}

resource "kubernetes_manifest" "registry_test_deployment" {
  manifest = yamldecode(templatefile("${path.module}/deployment.yaml.tftpl", {
    deployment_name   = var.deployment_name
    namespace_name    = kubernetes_namespace.test_namespace.metadata[0].name
    deployment_labels = var.deployment_labels
    replica_count     = var.replica_count
    app_name         = var.app_name
    
    # Container configurations
    container_name    = var.container_name
    container_image   = local.selected_images.web_server
    container_port    = var.container_port
    
    sidecar_name     = var.sidecar_name
    sidecar_image    = local.selected_images.sidecar
    sidecar_port     = var.sidecar_port
    
    init_container_name  = var.init_container_name
    init_container_image = local.selected_images.init
    
    # Environment and configuration
    environment       = var.environment
    app_version      = var.app_version
    registry_type    = var.use_authorized_registry ? "authorized" : "unauthorized"
    
    # Health checks
    health_check_path = var.health_check_path
  }))
}
