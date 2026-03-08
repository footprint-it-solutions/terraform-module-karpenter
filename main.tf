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
  version          = "1.8.2"

  set = concat([
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.this.arn
    },
    {
      name  = "settings.clusterName"
      value = var.cluster_name
    }
  ], [
    for gate, enabled in var.feature_gates : {
      name  = "settings.featureGates.${gate}"
      value = tostring(enabled)
    }
  ])

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
  take_ownership = true

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

  set_list = [
    {
      name  = "allowedArch"
      value = var.allowed_arch
    }
  ]

  values = [
    file("${path.module}/helm/values.yaml"),
    <<-EOT
---
expireAfter: ${var.expire_after}
imageGCHighThresholdPercent: ${var.image_gc_high_threshold_percent}
imageGCLowThresholdPercent: ${var.image_gc_low_threshold_percent}

hlb:
  enabled: ${var.hlb != null}
  amiId: "${var.hlb != null ? var.hlb.ami_id : ""}"

al2023:
  enabled: ${var.enable_al2023}
  topologySpreadConstraints: ${var.al2023_topology_spread_constraints}
  extraRequirements: ${var.al2023_extra_requirements}
bottlerocket:
  enabled: ${var.enable_bottlerocket}
  topologySpreadConstraints: ${var.bottlerocket_topology_spread_constraints}
  extraRequirements: ${var.bottlerocket_extra_requirements}

al2023UserData: |-
${indent(2, var.al2023_userdata)}
bottlerocketUserData: |-
${indent(2, var.bottlerocket_userdata)}

%{if var.block_device_mappings != ""~}
${var.block_device_mappings}
%{endif~}
    EOT
  ]
}
