# Terraform Module for Karpenter

This module deploys Karpenter on EKS, using Fargate. This makes it possible to operate
an EKS cluster without managed node groups (MNGs).

## Usage

This module now supports dynamic configuration of `NodePool` and `EC2NodeClass` resources.

### Example: Custom Node Pool and Node Class

```hcl
module "karpenter" {
  source = "footprint-it/karpenter/aws"

  cluster_name           = "my-cluster"
  aws_account_id         = "123456789012"
  aws_region             = "eu-west-1"
  oidc_provider          = module.eks.oidc_provider
  node_security_group_id = module.eks.node_security_group_id

  node_pools = [
    {
      name           = "general-purpose"
      node_class_ref = "default"
      requirements = [
        { key = "karpenter.sh/capacity-type", operator = "In", values = ["on-demand"] },
        { key = "kubernetes.io/arch", operator = "In", values = ["amd64"] },
      ]
      limits = {
        cpu    = "1000"
        memory = "1000Gi"
      }
    }
  ]

  node_classes = [
    {
      name       = "default"
      ami_family = "AL2023"
      subnet_selector_terms = [
        { tags = { "karpenter.sh/discovery" = "my-cluster" } }
      ]
      security_group_selector_terms = [
        { tags = { "karpenter.sh/discovery" = "my-cluster" } }
      ]
    }
  ]
}
```

## Changes

Changes to this module are captured in the [CHANGELOG](./CHANGELOG.md).
