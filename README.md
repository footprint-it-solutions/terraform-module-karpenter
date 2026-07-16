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

## Changes

Changes to this module are captured in the [CHANGELOG](./CHANGELOG.md).
