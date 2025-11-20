variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
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
