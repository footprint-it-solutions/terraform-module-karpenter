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

variable "excluded_instance_sizes" {
  description = "AWS instance sizes to exclude from the NodePools (e.g. nano, micro, small, medium)"
  type        = set(string)
  default     = [
    "nano",
    "micro",
    "small",
    "medium"
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

variable "consolidate_after" {
  description = "Controls how long Karpenter waits before consolidating nodes"
  type        = string
  default     = "120s"
}

variable "expire_after" {
  description = "This ensures nodes are recycled weekly, preventing the accumulation of stale images over long periods."
  type        = string
  default     = "168h" # 7 days
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

variable "block_device_mappings" {
  description = "Block device mappings for the EC2NodeClasses"
  type        = string
  default     = ""
}

variable "feature_gates" {
  description = "Feature gates to enable or disable in the Karpenter controller"
  type        = map(bool)
  default     = {}
}

variable "al2023_userdata" {
  description = "Custom UserData for AL2023 nodes. This will be merged with Karpenter's default bootstrap script."
  type        = string
  default     = ""
}

variable "bottlerocket_userdata" {
  description = "Custom UserData for Bottlerocket nodes. Should be in TOML format."
  type        = string
  default     = ""
}

variable "enable_al2023" {
  description = "Enable the AL2023 NodePool and EC2NodeClass"
  type        = bool
  default     = true
}

variable "enable_bottlerocket" {
  description = "Enable the Bottlerocket NodePool and EC2NodeClass"
  type        = bool
  default     = true
}

variable "node_pools" {
  description = "Map of NodePool definitions"
  type        = any
  default     = {}
}

variable "al2023_topology_spread_constraints" {
  description = "Topology spread constraints for AL2023 NodePool (YAML string)"
  type        = string
  default     = "[]"
}

variable "al2023_extra_requirements" {
  description = "Extra requirements for AL2023 NodePool (YAML string)"
  type        = string
  default     = "[]"
}

variable "bottlerocket_topology_spread_constraints" {
  description = "Topology spread constraints for Bottlerocket NodePool (YAML string)"
  type        = string
  default     = "[]"
}

variable "bottlerocket_extra_requirements" {
  description = "Extra requirements for Bottlerocket NodePool (YAML string)"
  type        = string
  default     = "[]"
}

variable "karpenter_version" {
  description = "The version of the Karpenter Helm chart to deploy. This can be overridden to utilise a specific version."
  type        = string
  default     = "1.14.0"
}
