output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value     = module.eks.cluster_endpoint
  sensitive = true
}


output "jenkins_deployer_role_arn" {
  value = local.jenkins_role_arn
}

output "load_balancer_controller_role_arn" {
  value = module.load_balancer_controller_irsa.iam_role_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}
