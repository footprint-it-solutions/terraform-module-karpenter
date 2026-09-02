# Terraform Module for Karpenter

This module deploys Karpenter on EKS, utilising AWS Fargate. This makes it possible to operate an EKS cluster without managed node groups (MNGs).

## Usage

```hcl
module "karpenter" {
  source  = "footprint-it-solutions/karpenter/aws"
  version = "2.7.0"

  cluster_name           = "my-eks-cluster"
  aws_account_id         = "123456789012"
  aws_region             = "eu-west-2"
  oidc_provider          = "oidc.eks.eu-west-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E"
  node_security_group_id = "sg-0123456789abcdef0"

  # Optionally override the Karpenter Helm chart version (defaults to "1.14.0")
  karpenter_version = "1.14.0"
}
```

## Features

- Deploys Karpenter utilising AWS Fargate for serverless node provisioning.
- Native SQS queue and EventBridge rules for EKS interruption handling.
- Flexible configuration of multi-architecture NodePools and EC2NodeClasses.

## Portability & Customisation

This module is built for enterprise-grade portability, allowing you to pass through Helm values and configurations from Terraform to support varied environments and customer architectures.

### Key Customisable Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `node_iam_role_name` | The name of the IAM role for Karpenter-managed EKS nodes. | `"eks-node"` |
| `controller_resources` | Limits and requests for the Karpenter controller container. | *Standard limits (512Mi/250m)* |
| `controller_replicas` | Number of Karpenter controller replicas to run (useful for scaling down in dev/sandboxes). | `1` |
| `controller_node_selector` | Custom node selector map for placement of Karpenter controller pods. | `{}` |
| `controller_tolerations` | Custom list of node tolerations for the Karpenter controller pods. | `[]` |
| `controller_affinity` | Custom affinity rule block for Karpenter controller pods. | `{}` |
| `subnet_selector_terms` | Custom subnet selector terms for EC2NodeClasses. Defaults to EKS auto-discovery by cluster name tags. | `null` |
| `security_group_selector_terms` | Custom security group selector terms for EC2NodeClasses. Defaults to auto-discovery by cluster name tags. | `null` |
| `al2023_ami_selector_terms` | Custom AMI selector terms for default AL2023 EC2NodeClasses. | `null` |
| `bottlerocket_ami_selector_terms` | Custom AMI selector terms for default Bottlerocket EC2NodeClasses. | `null` |
| `al2023_node_pool_weight` | Preference weight for default AL2023 nodes over Bottlerocket. | `10` |
| `bottlerocket_node_pool_weight` | Preference weight for default Bottlerocket nodes over AL2023. | `20` |
| `kubelet_max_pods` | Configures `maxPods` on default EC2NodeClasses (important for custom networking/CNIs). | `110` |
| `metadata_options` | Instance metadata options (IMDSv2 settings) for EC2NodeClasses. | *Secure defaults (hop limit 2, tokens required)* |

## Changes

Changes to this module are captured in the [CHANGELOG](./CHANGELOG.md).
