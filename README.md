# Terraform Module for Karpenter

This module deploys Karpenter on EKS, using Fargate. This makes it possible to operate
an EKS cluster without managed node groups (MNGs).

## Features

- Dynamic creation of arbitrary Karpenter `NodePool` and `EC2NodeClass` resources via `node_pools` and `node_classes` variables.
- Support for sharing a single `EC2NodeClass` across multiple `NodePools`.
- Configurable instance size exclusions (e.g., nano, micro, small, medium).
- Built-in support for AL2023 and Bottlerocket AMI families.
- Automated node recycling (default 7 days) and garbage collection tuning.

## Usage

### Basic Usage with Dynamic Configuration

The new dynamic configuration method allows you to define multiple NodePools and EC2NodeClasses as maps.

```hcl
module "karpenter" {
  source = "path/to/module"

  cluster_name   = "my-cluster"
  aws_account_id = "123456789012"
  aws_region     = "eu-west-2"
  oidc_provider  = "oidc.eks.eu-west-2.amazonaws.com/id/EXAMPLE"
  node_security_group_id = "sg-12345678"

  node_classes = {
    "custom-class" = {
      amiFamily = "AL2023"
      amiAlias  = "al2023@v20251007"
      blockDeviceMappings = {
        "/dev/xvda" = {
          volumeSize = "50Gi"
          volumeType = "gp3"
        }
      }
    }
  }

  node_pools = {
    "general-purpose" = {
      nodeClassRef = "custom-class"
      weight       = 20
      extraRequirements = [
        {
          key      = "karpenter.sh/capacity-type"
          operator = "In"
          values   = ["on-demand"]
        }
      ]
    }
    "spot-pool" = {
      nodeClassRef = "custom-class"
      weight       = 10
      extraRequirements = [
        {
          key      = "karpenter.sh/capacity-type"
          operator = "In"
          values   = ["spot"]
        }
      ]
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | The OIDC provider URL | `string` | n/a | yes |
| <a name="input_node_security_group_id"></a> [node\_security\_group\_id](#input\_node\_security\_group\_id) | Security Group ID for EKS nodes | `string` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | A map of NodePool configurations to create. | `any` | `{}` | no |
| <a name="input_node_classes"></a> [node\_classes](#input\_node\_classes) | A map of EC2NodeClass configurations to create. | `any` | `{}` | no |
| <a name="input_allowed_arch"></a> [allowed\_arch](#input\_allowed\_arch) | Architectures to allow | `set(string)` | `["amd64"]` | no |
| <a name="input_excluded_instance_sizes"></a> [excluded\_instance\_sizes](#input\_excluded\_instance\_sizes) | AWS instance sizes to exclude | `set(string)` | `["nano", "micro", "small", "medium"]` | no |
| <a name="input_expire_after"></a> [expire\_after](#input\_expire\_after) | Node expiration duration | `string` | `"168h"` | no |
| <a name="input_enable_al2023"></a> [enable\_al2023](#input\_enable\_al2023) | Enable default AL2023 resources | `bool` | `true` | no |
| <a name="input_enable_bottlerocket"></a> [enable\_bottlerocket](#input\_enable\_bottlerocket) | Enable default Bottlerocket resources | `bool` | `true` | no |

## Changes

Changes to this module are captured in the [CHANGELOG](./CHANGELOG.md).
