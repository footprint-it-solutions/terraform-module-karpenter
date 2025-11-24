terraform {
  required_providers {
    helm       = {}
    kubernetes = {}
  }
}

resource "helm_release" "this" {
  provider = helm

  chart            = "karpenter"
  create_namespace = false
  name             = "karpenter"
  namespace        = "kube-system"
  repository       = "oci://public.ecr.aws/karpenter"
  take_ownership   = true
  version          = "1.7.1"

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.this.arn
    },
    {
      name  = "settings.clusterName"
      value = var.cluster_name
    }
  ]

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "extras" {
  provider = helm

  depends_on = [
    helm_release.this
  ]

  chart            = "${path.module}/helm"
  create_namespace = false
  name             = "karpenter-extras"
  namespace        = "kube-system"
  # Take over any resources created by alternative installation methods
  take_ownership   = true

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "awsRegion"
      value = var.aws_region
    },
    {
      name  = "serviceAccountName"
      value = var.service_account_name
    },
    {
      name  = "nodeSecurityGroupId"
      value = var.node_security_group_id
    }
  ]

  values = [
    file("${path.module}/helm/values.yaml"),
    <<-EOT
---
expireAfter: ${var.expire_after}
imageGCHighThresholdPercent: ${var.image_gc_high_threshold_percent}
imageGCLowThresholdPercent: ${var.image_gc_low_threshold_percent}
volumeSize: ${var.volume_size}
%{ if var.block_device_mappings != "" ~}
${trimspace(var.block_device_mappings)}
%{ endif ~}
%{ if var.node_min_memory != null ~}
nodeMinMemory: ${var.node_min_memory}
%{ endif ~}
    EOT
  ]
}
