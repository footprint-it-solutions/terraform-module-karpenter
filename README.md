# Terraform Module for Karpenter

This module deploys Karpenter on EKS, using Fargate. This makes it possible to operate
an EKS cluster without managed node groups (MNGs).

## Using an OCI-based registry

### [Helm repositories in OCI-based registries](https://helm.sh/docs/topics/registries/#using-an-oci-based-registry)
A Helm repository is a way to house and distribute packaged Helm charts. We are using an OCI-based registry and to read the helm chart values file, use this command: `helm show values oci://<oci-registry-url>/<chart-name> --version <chart-version>`

You can also use the command: `helm show values oci://public.ecr.aws/karpenter/karpenter --version 1.7.1 > karpenter-helm-values.yaml` to output it into a YAML file for better viewing.

Source:
https://helm.sh/docs/topics/registries/#other-subcommands
