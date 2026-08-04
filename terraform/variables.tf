variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "prod"
  validation {
    condition     = var.environment == "prod"
    error_message = "This stack is intentionally scoped to prod."
  }
}

variable "cluster_version" {
  description = "Use a currently supported EKS version validated by your organization"
  type        = string
  default     = "1.34"
}

variable "vpc_cidr" {
  type    = string
  default = "10.60.0.0/16"
}

variable "admin_principal_arn" {
  description = "IAM Identity Center role or break-glass role granted cluster admin"
  type        = string
}

variable "jenkins_principal_arn" {
  description = "IAM role used by Jenkins. Set an existing role ARN or leave blank to create one."
  type        = string
  default     = ""
}

variable "hosted_zone_arn" {
  description = "Optional Route53 hosted-zone ARN for ExternalDNS"
  type        = string
  default     = ""
}

variable "node_instance_types" {
  type    = list(string)
  default = ["m7i.large", "m6i.large"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

