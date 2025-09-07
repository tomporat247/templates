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

variable "use_authorized_registry" {
  description = "When set to true, uses authorized registry. Default false for testing registry restriction policies"
  type        = bool
  default     = false
}

variable "unauthorized_registry_base" {
  description = "Base URL for unauthorized registry (e.g., Docker Hub, Quay.io)"
  type        = string
  default     = "docker.io"
  validation {
    condition = contains([
      "docker.io", "quay.io", "gcr.io", "registry-1.docker.io",
      "k8s.gcr.io", "ghcr.io", "public.ecr.aws"
    ], var.unauthorized_registry_base)
    error_message = "Unauthorized registry must be one of: docker.io, quay.io, gcr.io, registry-1.docker.io, k8s.gcr.io, ghcr.io, public.ecr.aws."
  }
}

variable "unauthorized_init_registry" {
  description = "Registry for init container from unauthorized source"
  type        = string
  default     = "quay.io"
}

variable "authorized_registry_base" {
  description = "Base URL for authorized/approved registry (e.g., ECR, private registry)"
  type        = string
  default     = "123456789012.dkr.ecr.us-east-1.amazonaws.com"
}

variable "image_tag" {
  description = "Tag for the main container image"
  type        = string
  default     = "latest"
}

variable "sidecar_tag" {
  description = "Tag for the sidecar container image"
  type        = string
  default     = "1.35"
}

variable "init_tag" {
  description = "Tag for the init container image"
  type        = string
  default     = "3.18"
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace"
  type        = string
  default     = "registry-policy-test"
}

variable "namespace_labels" {
  description = "Labels to apply to the namespace"
  type        = map(string)
  default = {
    purpose = "registry-restriction-testing"
    security-policy = "image-source-validation"
  }
}

variable "deployment_name" {
  description = "Name of the Kubernetes deployment"
  type        = string
  default     = "registry-test-deployment"
}

variable "deployment_labels" {
  description = "Labels to apply to the deployment"
  type        = map(string)
  default = {
    app = "registry-test"
    purpose = "image-source-testing"
    security-test = "registry-restrictions"
  }
}

variable "app_name" {
  description = "Application name used for pod selector"
  type        = string
  default     = "registry-test-app"
}

variable "replica_count" {
  description = "Number of pod replicas"
  type        = number
  default     = 1
  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 10
    error_message = "Replica count must be between 1 and 10."
  }
}

variable "container_name" {
  description = "Name of the main container"
  type        = string
  default     = "web-server"
}

variable "container_port" {
  description = "Port exposed by the main container"
  type        = number
  default     = 80
}

variable "sidecar_name" {
  description = "Name of the sidecar container"
  type        = string
  default     = "monitoring-sidecar"
}

variable "sidecar_port" {
  description = "Port exposed by the sidecar container"
  type        = number
  default     = 8080
}

variable "init_container_name" {
  description = "Name of the init container"
  type        = string
  default     = "setup-init"
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
