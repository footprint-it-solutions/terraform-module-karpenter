# Terraform Module for Karpenter

This module deploys Karpenter on EKS, using Fargate. This makes it possible to operate
an EKS cluster without managed node groups (MNGs).

## Usage

This module can be used to deploy Karpenter with support for both Amazon Linux 2023 (AL2023) and Bottlerocket nodes. You can customise the NodePools using the provided variables to suit your workload requirements.

### Key Configuration Options

- **NodePool Weights:** Use `al2023_node_pool_weight` and `bottlerocket_node_pool_weight` to control scheduling priority across different AMI families.
- **AMI Families:** Enable or disable AMI families using `enable_al2023` and `enable_bottlerocket`.
- **Custom UserData:** Provide custom bootstrap logic via `al2023_userdata` and `bottlerocket_userdata`.
- **Scheduling Constraints:** Define `topologySpreadConstraints` and `extraRequirements` as YAML strings for fine-grained control over pod placement.
- **Instance Exclusion:** Exclude specific instance sizes (e.g., nano, micro) using the `excluded_instance_sizes` variable.

## Changes

Changes to this module are captured in the [CHANGELOG](./CHANGELOG.md).
