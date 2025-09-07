variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = null
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace"
  type        = string
  default     = "test-no-limits"
}

variable "namespace_labels" {
  description = "Labels to apply to the namespace"
  type        = map(string)
  default = {
    purpose = "resource-limits-testing"
    env     = "test"
  }
}

variable "deployment_name" {
  description = "Name of the Kubernetes deployment"
  type        = string
  default     = "no-limits-deployment"
}

variable "deployment_labels" {
  description = "Labels to apply to the deployment"
  type        = map(string)
  default = {
    app     = "test-app"
    purpose = "no-resource-limits"
  }
}

variable "app_name" {
  description = "Application name used for pod selector"
  type        = string
  default     = "test-app"
}

variable "replica_count" {
  description = "Number of pod replicas"
  type        = number
  default     = 2
}

variable "container_name" {
  description = "Name of the main container"
  type        = string
  default     = "web-server"
}

variable "container_image" {
  description = "Container image for the main container"
  type        = string
  default     = "nginx:1.21"
}

variable "container_port" {
  description = "Port exposed by the main container"
  type        = number
  default     = 80
}

variable "sidecar_image" {
  description = "Container image for the sidecar container"
  type        = string
  default     = "busybox:1.35"
}

variable "sidecar_port" {
  description = "Port exposed by the sidecar container"
  type        = number
  default     = 8080
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}

variable "app_version" {
  description = "Application version"
  type        = string
  default     = "1.0.0"
}

variable "health_check_path" {
  description = "Path for health check endpoints"
  type        = string
  default     = "/"
}

variable "add_resource_limits" {
  description = "When set to true, adds resource limits to containers. Default false for testing non-compliant deployments"
  type        = bool
  default     = false
}
