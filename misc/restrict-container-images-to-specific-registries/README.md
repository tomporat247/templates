# Restrict Container Images to Specific Registries - Test Template

This template creates a Kubernetes deployment that **intentionally uses unauthorized container registries** to test image source restriction policies, admission controllers, or OPA rules that enforce container registry governance.

## Purpose

This template is designed for testing scenarios where you need to validate that your Kubernetes security policies correctly:
- Block containers from unauthorized public registries
- Enforce use of approved private registries (ECR, Harbor, etc.)
- Validate image source compliance policies
- Test admission webhook functionality for registry restrictions

## Resources Created

- **Namespace**: A test namespace for the deployment
- **Deployment Manifest**: A Kubernetes deployment with 3 containers from different registry sources:
  - **Main Container**: nginx web server
  - **Sidecar Container**: busybox monitoring container  
  - **Init Container**: alpine setup container

## Template Structure

- **`deployment.yaml.tftpl`**: YAML template file containing the Kubernetes deployment specification
- **`main.tf`**: Uses `templatefile()` function to render the YAML template with registry variables
- **`kubernetes_manifest`**: Terraform resource that applies the rendered YAML to the cluster

## Registry Sources

### Unauthorized Registries (Default - for testing):
- **Docker Hub**: `docker.io/nginx:latest`
- **Quay.io**: `quay.io/alpine:3.18` 
- **Google Container Registry**: `gcr.io/project/image`
- **GitHub Container Registry**: `ghcr.io/owner/repo`
- **Public ECR**: `public.ecr.aws/something`

### Authorized Registries (when compliant):
- **Private ECR**: `123456789012.dkr.ecr.us-east-1.amazonaws.com/nginx:latest`
- **Private Harbor**: `harbor.company.com/library/nginx`  
- **Corporate Registry**: `registry.company.com/approved/nginx`

## Conditional Registry Selection

This template includes a `use_authorized_registry` variable that controls image sources:

- **When `use_authorized_registry = false` (default)**: Uses unauthorized public registries for testing policy enforcement
- **When `use_authorized_registry = true`**: Uses authorized private registries for compliant deployments

### Image Sources by Container:
- **Main Container**: Web server from primary registry
- **Sidecar**: Monitoring container from same registry as main
- **Init Container**: Setup container from different registry (tests mixed sources)

## Usage

### Basic Deployment (Unauthorized Registries)
```bash
terraform init
terraform plan
terraform apply
```

### Testing with Authorized Registries  
```bash
terraform apply -var="use_authorized_registry=true"
```

### Custom Registry Testing
```bash
# Test with different unauthorized registry
terraform apply \
  -var="unauthorized_registry_base=quay.io" \
  -var="unauthorized_init_registry=gcr.io"

# Test with custom authorized registry
terraform apply \
  -var="use_authorized_registry=true" \
  -var="authorized_registry_base=your-registry.company.com"
```

### Expected Behavior

If you have registry restriction policies in place:
- **OPA/Gatekeeper**: Should deny deployments using unauthorized registries
- **Admission Controllers**: Should reject manifests with non-approved image sources
- **Policy Engines**: Should flag registry compliance violations
- **Image Security Scanners**: Should block unsigned or untrusted images

If no registry policies are active:
- **Deployment will succeed** (indicating missing registry governance)
- **Containers will pull from public registries**
- **Security teams should be alerted**

## Testing Scenarios

1. **Registry Whitelist Validation**: Test that only approved registries are allowed
2. **Admission Controller Testing**: Validate webhook-based registry enforcement
3. **OPA Policy Testing**: Test Open Policy Agent rules for image sources
4. **Compliance Scanning**: Use with tools like Falco, Twistlock, or Aqua Security
5. **Security Training**: Demonstrate importance of registry governance

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| kubeconfig_path | Path to kubeconfig file | ~/.kube/config |
| kubeconfig_context | Kubernetes context to use | null |
| use_authorized_registry | Use authorized registry sources | false |
| unauthorized_registry_base | Base URL for unauthorized registry | docker.io |
| unauthorized_init_registry | Unauthorized registry for init container | quay.io |
| authorized_registry_base | Base URL for authorized registry | 123456789012.dkr.ecr.us-east-1.amazonaws.com |
| image_tag | Main container image tag | latest |
| sidecar_tag | Sidecar container image tag | 1.35 |
| init_tag | Init container image tag | 3.18 |
| namespace_name | Namespace for deployment | registry-policy-test |
| deployment_name | Name of the deployment | registry-test-deployment |
| replica_count | Number of pod replicas | 1 |

## Container Configuration

All containers include:
- **Resource Limits**: Proper CPU/memory constraints
- **Environment Variables**: Registry type and image source information  
- **Health Checks**: Liveness and readiness probes
- **Logging**: Container startup and registry information

## Security Policy Examples

### Example OPA Policy (should block this template by default):
```rego
package kubernetes.admission

deny[msg] {
  input.request.kind.kind == "Pod"
  image := input.request.object.spec.containers[_].image
  not starts_with(image, "your-approved-registry.com/")
  msg := "Container image must come from approved registry"
}
```

### Example Admission Controller Logic:
- Check each container image in the deployment
- Verify registry hostname against allowlist
- Reject if any image comes from unauthorized source

## Monitoring & Compliance

The template includes annotations and labels for:
- **Registry source tracking**: Identifies which registries are being used
- **Policy validation**: Clear indicators for compliance testing
- **Audit trails**: Container source information in metadata
- **Security scanning**: Integration points for image security tools

## Cleanup

```bash
terraform destroy
```

## Integration with Security Tools

This template works well with:
- **OPA/Gatekeeper**: Policy enforcement at admission time
- **Falco**: Runtime security monitoring for unauthorized images  
- **Twistlock/Prisma**: Registry and image compliance scanning
- **Harbor**: Private registry with policy enforcement
- **Admission Controllers**: Custom webhooks for registry validation

Use the `policy_test_info` output to understand expected policy behavior before deployment.
