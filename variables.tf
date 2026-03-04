variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "allowed_arch" {
  description = "Architectures to allow"
  type        = set(string)
  default     = [
    "amd64"
  ]
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "expire_after" {
  description = "This ensures nodes are recycled weekly, preventing the accumulation of stale images over long periods."
  type        = string
  default     = "168h" # 7 days
}

variable "hlb" {
  description = "Configuration for HLB. If provided, HLB is enabled."
  type = object({
    ami_id = string
  })
  default = null
}

variable "image_gc_high_threshold_percent" {
  description = "Garbage collection starts at 70% to prevent disk pressure (eviction usually starts at 85%)"
  type        = number
  default     = 70
}

variable "image_gc_low_threshold_percent" {
  description = "Garbage collection targets 50% usage after GC to ensure ample space for new images"
  type        = number
  default     = 50
}

variable "oidc_provider" {
  description = "The OIDC provider URL"
  type        = string
}

variable "service_account_name" {
  description = "Service account name for Karpenter"
  type        = string
  default     = "karpenter"
}

variable "iam_permissions_boundary" {
  description = "IAM permissions boundary ARN for Karpenter role"
  type        = string
  default     = null
}

variable "node_security_group_id" {
  description = "Security Group ID for EKS nodes"
  type        = string
}

variable "node_pools" {
  description = "List of NodePool configurations. If null, defaults to AL2023 and Bottlerocket pools based on legacy variables."
  type = list(object({
    name           = string
    node_class_ref = string
    weight         = optional(number)
    requirements = list(object({
      key      = string
      operator = string
      values   = list(string)
    }))
    disruption = optional(object({
      consolidation_policy = optional(string, "WhenEmptyOrUnderutilized")
      consolidate_after    = optional(string, "30s")
      expire_after         = optional(string, "720h")
    }))
    limits = optional(map(string), {})
    kubelet = optional(object({
      image_gc_high_threshold_percent = optional(number)
      image_gc_low_threshold_percent  = optional(number)
    }))
    startup_taints = optional(list(object({
      key    = string
      value  = optional(string)
      effect = string
    })), [])
  }))
  default = null
}

variable "node_classes" {
  description = "List of EC2NodeClass configurations. If null, defaults to AL2023 and Bottlerocket classes."
  type = list(object({
    name                          = string
    ami_family                    = string
    ami_selector_terms            = optional(list(any), [])
    subnet_selector_terms         = list(any)
    security_group_selector_terms = list(any)
    role                          = optional(string, "eks-node")
    metadata_options = optional(object({
      httpEndpoint            = optional(string, "enabled")
      httpProtocolIPv6        = optional(string, "disabled")
      httpPutResponseHopLimit = optional(number, 2)
      httpTokens              = optional(string, "required")
    }), {
      httpEndpoint            = "enabled"
      httpProtocolIPv6        = "disabled"
      httpPutResponseHopLimit = 2
      httpTokens              = "required"
    })
    block_device_mappings = optional(list(object({
      deviceName = string
      ebs = object({
        volumeSize          = string
        volumeType          = string
        encrypted           = optional(bool, true)
        deleteOnTermination = optional(bool, true)
      })
    })), [])
    tags = optional(map(string), {})
  }))
  default = null
}

variable "block_device_mappings" {
  description = "(Deprecated) Block device mappings. Use var.node_classes for new configurations."
  type        = string
  default     = ""
}

variable "feature_gates" {
  description = "Feature gates to enable or disable in the Karpenter controller"
  type        = map(bool)
  default     = {}
}
