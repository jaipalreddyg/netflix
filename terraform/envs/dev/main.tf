locals {
  name = "${var.project_name}-${var.environment}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name       = local.name
  cidr_block = "10.20.0.0/16"
  az_count   = 2
  tags       = local.tags
}

module "eks" {
  source = "../../modules/eks"

  name            = local.name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  tags            = local.tags
}

module "jenkins" {
  source = "../../modules/jenkins"

  name             = "${local.name}-jenkins"
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  key_name         = var.key_name
  admin_cidr       = var.admin_cidr
  eks_cluster_name = module.eks.cluster_name
  tags             = local.tags
}
