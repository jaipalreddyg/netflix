# AWS DevSecOps Netflix Clone Platform

Hands-on AWS DevOps project based on DevOps-Project-09, upgraded into a senior-style implementation with infrastructure as code, CI/CD, security scanning, Kubernetes deployment, and monitoring.

## What You Will Build

- AWS VPC with public and private subnets
- Jenkins controller on EC2
- Amazon EKS for Kubernetes workloads
- Docker Hub for container images
- Jenkins CI/CD pipeline
- SonarQube quality scanning
- OWASP Dependency Check
- Trivy filesystem and image scanning
- Prometheus and Grafana monitoring
- ALB Ingress for application access

## Repository Layout

```text
terraform/        AWS infrastructure
jenkins/          Jenkinsfile and bootstrap scripts
k8s/              Kubernetes application manifests
monitoring/       Prometheus and Grafana Helm values
scripts/          Operator helper scripts
docs/             Architecture, runbook, and troubleshooting
```

## High-Level Flow

1. Provision AWS infrastructure with Terraform.
2. Bootstrap Jenkins on EC2.
3. Configure Jenkins credentials and tools.
4. Run the CI/CD pipeline.
5. Build and scan the Docker image.
6. Push the image to Docker Hub as `jaipalreddyg/sample-app:<tag>`.
7. Deploy the app to EKS.
8. Monitor the platform with Prometheus and Grafana.

## Prerequisites

- AWS account
- AWS CLI configured
- Terraform
- kubectl
- Helm
- Git
- A GitHub fork of the application repository

## Start Here

Read [docs/implementation-guide.md](docs/implementation-guide.md).
