output "jenkins_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance."
  value       = module.jenkins.public_ip
}


output "eks_cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
