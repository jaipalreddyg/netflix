# Terraform

This directory provisions the AWS foundation for the project.

## Modules

  `modules/vpc`: networking
  Container images are stored in Docker Hub under `jaipalreddyg`.
  `modules/jenkins`: Jenkins EC2 instance
  `modules/eks`: EKS cluster and managed node group

## Usage

```powershell
cd terraform/envs/dev
terraform init
terraform plan
terraform apply
```

For production work, configure `backend.tf` with an S3 bucket and DynamoDB lock table before running `terraform init`.
