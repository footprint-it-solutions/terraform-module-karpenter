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

variable "node_iam_role_name" {
  description = "The name of the IAM role for Karpenter-managed EKS nodes"
  type        = string
  default     = "eks-node"
}

variable "controller_resources" {
  description = "Limits and requests for the Karpenter controller container resources"
  type        = any
  default = {
    limits = {
      cpu    = "250m"
      memory = "512Mi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "controller_replicas" {
  description = "Number of Karpenter controller replicas to run in the cluster"
  type        = number
  default     = 1
}

variable "controller_node_selector" {
  description = "Node selector for Karpenter controller pods"
  type        = map(string)
  default     = {}
}

variable "controller_tolerations" {
  description = "List of node tolerations for Karpenter controller pods"
  type        = list(any)
  default     = []
}

variable "controller_affinity" {
  description = "Affinity rules for Karpenter controller pods"
  type        = any
  default     = {}
}

variable "subnet_selector_terms" {
  description = "Custom subnet selector terms for the default AL2023 and Bottlerocket EC2NodeClasses. If not specified, defaults to discovery by cluster name tag."
  type        = list(any)
  default     = null
}

variable "security_group_selector_terms" {
  description = "Custom security group selector terms for the default AL2023 and Bottlerocket EC2NodeClasses. If not specified, defaults to discovery by cluster name tag."
  type        = list(any)
  default     = null
}

variable "al2023_ami_selector_terms" {
  description = "Custom AMI selector terms for the default AL2023 EC2NodeClass"
  type        = list(any)
  default     = null
}

variable "bottlerocket_ami_selector_terms" {
  description = "Custom AMI selector terms for the default Bottlerocket EC2NodeClass"
  type        = list(any)
  default     = null
}

variable "al2023_node_pool_weight" {
  description = "The preference weight assigned to the default AL2023 NodePool"
  type        = number
  default     = 10
}

variable "bottlerocket_node_pool_weight" {
  description = "The preference weight assigned to the default Bottlerocket NodePool"
  type        = number
  default     = 20
}

variable "kubelet_max_pods" {
  description = "Configures the default maxPods value for EKS nodes provisioned by the default NodePools"
  type        = number
  default     = 110
}

variable "metadata_options" {
  description = "The instance metadata options (IMDS) configured on provisioned nodes"
  type        = map(any)
  default = {
    httpEndpoint            = "enabled"
    httpProtocolIPv6        = "disabled"
    httpPutResponseHopLimit = 2
    httpTokens              = "required"
  }
}

