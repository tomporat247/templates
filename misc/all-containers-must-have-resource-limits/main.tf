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

resource "kubernetes_deployment" "no_resource_limits" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.test_namespace.metadata[0].name
    labels    = var.deployment_labels
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.container_image

          port {
            container_port = var.container_port
          }

          env {
            name  = "ENV"
            value = var.environment
          }

          env {
            name  = "APP_VERSION"
            value = var.app_version
          }

          liveness_probe {
            http_get {
              path = var.health_check_path
              port = var.container_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = var.health_check_path
              port = var.container_port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          dynamic "resources" {
            for_each = var.add_resource_limits ? [1] : []
            content {
              limits = {
                cpu    = "500m"
                memory = "512Mi"
              }
              requests = {
                cpu    = "250m"
                memory = "256Mi"
              }
            }
          }
        }

        container {
          name  = "${var.container_name}-sidecar"
          image = var.sidecar_image

          port {
            container_port = var.sidecar_port
          }

          env {
            name  = "SIDECAR_MODE"
            value = "enabled"
          }

          dynamic "resources" {
            for_each = var.add_resource_limits ? [1] : []
            content {
              limits = {
                cpu    = "200m"
                memory = "128Mi"
              }
              requests = {
                cpu    = "100m"
                memory = "64Mi"
              }
            }
          }
        }
      }
    }
  }
}
