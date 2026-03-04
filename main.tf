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

locals {
  # Default Node Pools (AL2023 & Bottlerocket) to maintain parity
  default_node_pools = concat([
    {
      name           = "al2023"
      node_class_ref = "al2023"
      requirements = [
        { key = "karpenter.k8s.aws/instance-hypervisor", operator = "In", values = ["nitro"] },
        { key = "kubernetes.io/arch", operator = "In", values = tolist(var.allowed_arch) },
        { key = "kubernetes.io/os", operator = "In", values = ["linux"] },
        { key = "karpenter.sh/capacity-type", operator = "In", values = ["on-demand", "spot"] },
        { key = "karpenter.k8s.aws/instance-category", operator = "In", values = ["c", "g", "m", "r"] },
        { key = "karpenter.k8s.aws/instance-generation", operator = "Gt", values = ["2"] }
      ]
      disruption = {
        expire_after = var.expire_after
      }
      kubelet = {
        image_gc_high_threshold_percent = var.image_gc_high_threshold_percent
        image_gc_low_threshold_percent  = var.image_gc_low_threshold_percent
      }
    },
    {
      name           = "bottlerocket"
      node_class_ref = "bottlerocket"
      requirements = [
        { key = "karpenter.k8s.aws/instance-hypervisor", operator = "In", values = ["nitro"] },
        { key = "kubernetes.io/arch", operator = "In", values = tolist(var.allowed_arch) },
        { key = "kubernetes.io/os", operator = "In", values = ["linux"] },
        { key = "karpenter.sh/capacity-type", operator = "In", values = ["on-demand", "spot"] },
        { key = "karpenter.k8s.aws/instance-category", operator = "In", values = ["c", "g", "m", "r"] },
        { key = "karpenter.k8s.aws/instance-generation", operator = "Gt", values = ["2"] }
      ]
      disruption = {
        expire_after = var.expire_after
      }
      kubelet = {
        image_gc_high_threshold_percent = var.image_gc_high_threshold_percent
        image_gc_low_threshold_percent  = var.image_gc_low_threshold_percent
      }
    }
  ], var.hlb != null ? [
    {
      name           = "hlb-ami-86"
      node_class_ref = "hlb-ami-x86"
      requirements = [
        { key = "karpenter.k8s.aws/instance-hypervisor", operator = "In", values = ["nitro"] },
        { key = "kubernetes.io/arch", operator = "In", values = tolist(var.allowed_arch) },
        { key = "kubernetes.io/os", operator = "In", values = ["linux"] },
        { key = "karpenter.sh/capacity-type", operator = "In", values = ["on-demand", "spot"] },
        { key = "karpenter.k8s.aws/instance-category", operator = "In", values = ["c", "m", "r"] },
        { key = "karpenter.k8s.aws/instance-generation", operator = "Gt", values = ["2"] }
      ]
      disruption = {
        expire_after = var.expire_after
      }
      kubelet = {
        image_gc_high_threshold_percent = var.image_gc_high_threshold_percent
        image_gc_low_threshold_percent  = var.image_gc_low_threshold_percent
      }
      startup_taints = [
        {
          key    = "node-role.kubernetes.io/hlb"
          effect = "NoSchedule"
        }
      ]
    }
  ] : [])

  # Default Node Classes
  default_node_classes = concat([
    {
      name       = "al2023"
      ami_family = "AL2023"
      ami_selector_terms = [
        { alias = "al2023@v20251007" }
      ]
      subnet_selector_terms = [
        { tags = { "karpenter.sh/discovery" = var.cluster_name } }
      ]
      security_group_selector_terms = [
        { tags = { "karpenter.sh/discovery" = var.cluster_name } }
      ]
      block_device_mappings = [
        {
          deviceName = "/dev/xvda"
          ebs = {
            volumeSize = "40Gi"
            volumeType = "gp3"
          }
        }
      ]
    },
    {
      name       = "bottlerocket"
      ami_family = "Bottlerocket"
      ami_selector_terms = [
        { alias = "bottlerocket@1.50.0" }
      ]
      subnet_selector_terms = [
        { tags = { "karpenter.sh/discovery" = var.cluster_name } }
      ]
      security_group_selector_terms = [
        { tags = { "karpenter.sh/discovery" = var.cluster_name } }
      ]
      block_device_mappings = [
        {
          deviceName = "/dev/xvda"
          ebs = {
            volumeSize = "8Gi"
            volumeType = "gp3"
          }
        },
        {
          deviceName = "/dev/xvdb"
          ebs = {
            volumeSize = "40Gi"
            volumeType = "gp3"
          }
        }
      ]
    }
  ], var.hlb != null ? [
    {
      name       = "hlb-ami-x86"
      ami_family = "AL2"
      ami_selector_terms = [
        { id = var.hlb.ami_id }
      ]
      subnet_selector_terms = [
        { tags = { "karpenter.sh/discovery" = var.cluster_name } }
      ]
      security_group_selector_terms = [
        { tags = { "karpenter.sh/discovery" = var.cluster_name } }
      ]
      block_device_mappings = [
        {
          deviceName = "/dev/xvda"
          ebs = {
            volumeSize = "40Gi"
            volumeType = "gp3"
          }
        }
      ]
    }
  ] : [])

  # Selection Logic
  node_pools_final   = var.node_pools != null ? var.node_pools : local.default_node_pools
  node_classes_final = var.node_classes != null ? var.node_classes : local.default_node_classes
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

  values = [
    file("${path.module}/helm/values.yaml"),
    yamlencode({
      clusterName         = var.cluster_name
      awsRegion           = var.aws_region
      serviceAccountName  = var.service_account_name
      nodeSecurityGroupId = var.node_security_group_id
      allowedArch         = tolist(var.allowed_arch)
      nodePools           = local.node_pools_final
      ec2NodeClasses      = local.node_classes_final
      hlb = {
        enabled = var.hlb != null
        amiId   = var.hlb != null ? var.hlb.ami_id : ""
      }
      # Deprecated block device mappings passed for compatibility if needed
      blockDeviceMappingsLegacy = var.block_device_mappings
    })
  ]
}
