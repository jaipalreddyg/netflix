# Troubleshooting

## Terraform Cannot Create EKS

Check service quotas for EKS, EC2 instances, and VPC resources in the target region.

## Jenkins Cannot Use Docker

Restart Jenkins after adding it to the Docker group:

```bash
sudo systemctl restart jenkins
```

## Jenkins Cannot Push To Docker Hub

Verify:

```bash
aws sts get-caller-identity
docker login --username jaipalreddyg
```

Jenkins must have a username/password credential named `dockerhub-jaipalreddyg`; use your Docker Hub username and an access token as the password.

## kubectl Access Denied

Update kubeconfig:

```powershell
aws eks update-kubeconfig --region ap-south-1 --name devsecops-netflix-dev
```

Then configure EKS access entries or the `aws-auth` ConfigMap for the Jenkins role.

## ALB Ingress Does Not Work

Install AWS Load Balancer Controller and confirm the private/public subnet tags are present.

## Grafana Password

This scaffold uses `change-me-after-install` for the lab. Change it after the first login or move it to a Kubernetes secret.
