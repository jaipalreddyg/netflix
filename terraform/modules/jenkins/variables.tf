variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "admin_cidr" {
  type = string
}


variable "eks_cluster_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
