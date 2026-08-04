# Architecture

## Components

- Developer pushes code to GitHub.
- Jenkins runs the CI/CD workflow from an EC2 instance.
- SonarQube provides static code quality checks.
- OWASP Dependency Check scans application dependencies.
- Trivy scans source files and Docker images.
- Docker image is pushed to Docker Hub under `jaipalreddyg`.
- Jenkins deploys the image to Amazon EKS.
- AWS Load Balancer Controller exposes the application through ALB Ingress.
- Prometheus scrapes metrics.
- Grafana visualizes platform and workload health.

## AWS Services

- VPC
- EC2
- IAM
- EKS
- Docker Hub
- ALB
- CloudWatch
- S3 and DynamoDB for Terraform state locking

## Security Principles

- Use private subnets for worker nodes.
- Restrict Jenkins and SonarQube access to your public IP.
- Prefer IAM roles over static AWS credentials.
- Store secrets in Jenkins credentials or AWS Secrets Manager.
- Keep security scanning in the delivery pipeline.
- Destroy lab resources when finished.
