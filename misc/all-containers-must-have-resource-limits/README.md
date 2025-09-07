# All Containers Must Have Resource Limits - Test Template

This template creates a Kubernetes deployment with **intentionally missing resource limits** to test validation policies, OPA rules, or admission controllers that enforce resource limit requirements.

## Purpose

This template is designed for testing scenarios where you need to validate that your Kubernetes policies correctly:
- Detect containers without resource limits
- Reject deployments that don't specify CPU/memory limits
- Enforce resource governance policies

## Resources Created

- **Namespace**: A test namespace for the deployment
- **Deployment Manifest**: A Kubernetes deployment manifest (YAML) with 2 containers (main + sidecar) that have **NO resource limits** by default

## Template Structure

- **`deployment.yaml.tftpl`**: YAML template file containing the Kubernetes deployment specification
- **`main.tf`**: Uses `templatefile()` function to render the YAML template with variables
- **`kubernetes_manifest`**: Terraform resource that applies the rendered YAML to the cluster

## Container Configuration

The deployment includes:
1. **Main Container**: nginx web server (no resource limits)
2. **Sidecar Container**: busybox utility container (no resource limits)

By default, both containers intentionally lack:
- CPU limits (`resources.limits.cpu`)
- Memory limits (`resources.limits.memory`)
- CPU requests (`resources.requests.cpu`)
- Memory requests (`resources.requests.memory`)

## Conditional Resource Limits

This template includes an `add_resource_limits` variable that allows you to toggle resource limits:

- **When `add_resource_limits = false` (default)**: Containers have NO resource limits (for testing non-compliance)
- **When `add_resource_limits = true`**: Containers include proper resource limits and requests

### Resource Specifications (when enabled):
- **Main Container**: 500m CPU / 512Mi memory (limits), 250m CPU / 256Mi memory (requests)
- **Sidecar Container**: 200m CPU / 128Mi memory (limits), 100m CPU / 64Mi memory (requests)

## Usage

### Basic Deployment
```bash
terraform init
terraform plan
terraform apply
```

### Testing with Custom Values
```bash
# Test non-compliant deployment (no resource limits)
terraform apply \
  -var="namespace_name=policy-test" \
  -var="deployment_name=test-deployment" \
  -var="replica_count=1"

# Test compliant deployment (with resource limits)
terraform apply \
  -var="add_resource_limits=true" \
  -var="namespace_name=policy-test"
```

### Expected Behavior

If you have policies enforcing resource limits:
- **OPA/Gatekeeper**: Should deny this deployment
- **Admission Controllers**: Should reject the manifest
- **Policy Engines**: Should flag as non-compliant

If no policies are active:
- **Deployment will succeed** (this indicates missing governance)
- Pods will run without resource constraints
- May lead to resource contention issues

## Testing Scenarios

1. **Policy Validation**: Deploy this template to verify resource limit policies work
2. **Admission Controller Testing**: Test webhook-based validation
3. **Compliance Scanning**: Use with tools like Falco, OPA, or Polaris
4. **Training**: Demonstrate importance of resource limits

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| kubeconfig_path | Path to kubeconfig file | ~/.kube/config |
| kubeconfig_context | Kubernetes context to use | null |
| namespace_name | Namespace for the deployment | test-no-limits |
| deployment_name | Name of the deployment | no-limits-deployment |
| app_name | Application name for selectors | test-app |
| replica_count | Number of pod replicas | 2 |
| container_name | Main container name | web-server |
| container_image | Main container image | nginx:1.21 |
| sidecar_image | Sidecar container image | busybox:1.35 |
| environment | Environment label | test |
| add_resource_limits | Add resource limits to containers | false |

## Security Warning

⚠️ **Important**: This template creates containers without resource limits, which can:
- Consume unlimited CPU/memory
- Impact cluster stability
- Cause resource starvation for other workloads

Only use this template in:
- Test environments
- Isolated clusters  
- Policy validation scenarios

## Cleanup

```bash
terraform destroy
```

This will remove the deployment and namespace, cleaning up all test resources.
