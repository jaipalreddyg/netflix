variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "devsecops-netflix"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "admin_cidr" {
  description = "CIDR allowed to access Jenkins, SonarQube, and Grafana admin endpoints."
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name for Jenkins SSH access."
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL for reference and tagging."
  type        = string
  default     = "https://github.com/NotHarshhaa/DevOps-Projects.git"
}
