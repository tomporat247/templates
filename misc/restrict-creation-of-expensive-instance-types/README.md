# Restrict Creation of Expensive Instance Types - Test Template

This template creates an AWS EC2 instance using **intentionally expensive G5 instance types** to test cost governance policies, budget controls, or organizational policies that restrict high-cost resources.

## Purpose

This template is designed for testing scenarios where you need to validate that your AWS policies correctly:
- Detect and block expensive instance type deployments
- Enforce cost control measures
- Validate budget guardrails and spending policies
- Test organizational units (OU) restrictions on instance types

## Resources Created

- **EC2 Instance**: Uses expensive G5 GPU instances by default (can cost $200-$5000+ per month!)
- **Security Group**: Basic security group with SSH, HTTP, and HTTPS access
- **Elastic IP** (optional): Static IP address for the instance
- **EBS Volume**: Root volume with configurable encryption

## Instance Types

### Expensive Types (G5 Family - GPU Instances):
- `g5.xlarge` - 4 vCPU, 16 GB RAM, 1 NVIDIA A10G GPU (~$1,000/month)
- `g5.2xlarge` - 8 vCPU, 32 GB RAM, 1 NVIDIA A10G GPU (~$2,000/month) **[DEFAULT]**
- `g5.4xlarge` - 16 vCPU, 64 GB RAM, 1 NVIDIA A10G GPU (~$3,500/month)
- `g5.8xlarge` - 32 vCPU, 128 GB RAM, 1 NVIDIA A10G GPU (~$6,000/month)
- And larger sizes up to `g5.48xlarge`

### Affordable Alternatives:
- `t3.micro` - 2 vCPU, 1 GB RAM (~$8/month)
- `t3.small` - 2 vCPU, 2 GB RAM (~$17/month) **[DEFAULT when cost-conscious]**
- `t3.medium` - 2 vCPU, 4 GB RAM (~$33/month)

## Conditional Instance Selection

This template includes a `use_expensive_instance` variable that controls instance type selection:

- **When `use_expensive_instance = true` (default)**: Uses G5 GPU instances for testing cost policies
- **When `use_expensive_instance = false`**: Uses affordable T3 instances for normal operations

## Usage

### Basic Deployment (Expensive Instance)
```bash
terraform init
terraform plan
terraform apply
```

⚠️ **WARNING**: This will launch an expensive G5 instance! Monitor your costs.

### Testing with Affordable Instance
```bash
terraform apply -var="use_expensive_instance=false"
```

### Custom Expensive Instance Type
```bash
terraform apply \
  -var="expensive_instance_type=g5.8xlarge" \
  -var="instance_name=mega-expensive-test"
```

### Expected Behavior

If you have cost governance policies in place:
- **Service Control Policies (SCPs)**: Should deny expensive instance launches
- **AWS Budgets**: Should trigger alerts or prevent deployment
- **Cost Anomaly Detection**: Should flag unusual spending
- **Custom Policies**: Should block based on instance family/type

If no cost controls are active:
- **Instance will launch successfully** (indicating missing governance!)
- **High costs will begin immediately** 
- **Should trigger budget alerts** if configured

## Testing Scenarios

1. **Cost Policy Validation**: Deploy to verify expensive instance restrictions work
2. **Budget Testing**: Test budget alert thresholds and actions
3. **SCP Testing**: Validate Service Control Policy enforcement
4. **Compliance Testing**: Ensure organizational cost controls are effective
5. **Training**: Demonstrate the importance of cost governance

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| aws_region | AWS region for deployment | us-east-1 |
| instance_name | Name for the EC2 instance | expensive-instance-test |
| use_expensive_instance | Use expensive G5 instance type | true |
| expensive_instance_type | Which G5 instance to use | g5.2xlarge |
| affordable_instance_type | Affordable alternative | t3.small |
| key_pair_name | SSH key pair name | null |
| root_volume_size | EBS root volume size (GB) | 20 |
| encrypt_root_volume | Encrypt root volume | true |
| allocate_elastic_ip | Allocate Elastic IP | false |
| environment | Environment label | test |

## Security & Cost Warnings

⚠️ **CRITICAL COST WARNING**: 
- G5 instances cost **$200-$5000+ per month**
- Costs begin **immediately** upon launch
- **Always terminate** after testing
- Set up billing alerts before using

⚠️ **Security Notes**:
- Security group allows SSH from anywhere (0.0.0.0/0)
- Use only in test environments
- Restrict source IPs in production scenarios

## Monitoring & Cleanup

The template includes:
- Cost monitoring script in user data
- Instance metadata logging
- Automatic tagging for cost tracking
- Clear identification as test resource

### Cleanup
```bash
terraform destroy
```

**Always verify destruction** to avoid ongoing charges!

## Integration with Cost Tools

This template works well with:
- **AWS Cost Explorer**: Track spending by tags
- **AWS Budgets**: Set spending limits and alerts  
- **Third-party tools**: CloudHealth, CloudCheckr, etc.
- **Custom monitoring**: Use output values for cost tracking

Use the `estimated_monthly_cost` output to understand potential charges before deployment.
