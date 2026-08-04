# Implementation Guide

## 1. Prepare AWS

Create or identify:

- An AWS CLI profile with admin access for the lab.
- An EC2 key pair.
- Your public IP address in CIDR format, for example `203.0.113.10/32`.
- Optional S3 bucket and DynamoDB table for Terraform state.

## 2. Configure Terraform

```powershell
cd terraform/envs/dev
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
admin_cidr = "YOUR_PUBLIC_IP/32"
key_name   = "YOUR_EC2_KEY_PAIR_NAME"
```

Initialize and apply:

```powershell
terraform init
terraform plan
terraform apply
```

## 3. Configure kubectl

Use the Terraform output:

```powershell
aws eks update-kubeconfig --region ap-south-1 --name devsecops-netflix-dev
kubectl get nodes
```

## 4. Bootstrap Jenkins

Open Jenkins:

```text
http://JENKINS_PUBLIC_IP:8080
```

Get the initial admin password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install these Jenkins plugins:

- Docker Pipeline
- SonarQube Scanner
- OWASP Dependency-Check
- Kubernetes CLI
- AWS Credentials
- Pipeline Stage View
- Email Extension
- Prometheus metrics

## 5. Start SonarQube

SSH into Jenkins and run:

```bash
bash jenkins/install-sonarqube.sh
```

Open:

```text
http://JENKINS_PUBLIC_IP:9000
```

Default SonarQube credentials are usually `admin` / `admin`. Change them immediately.

## 6. Configure Jenkins Credentials

Add:

- SonarQube token
- GitHub credentials if using a private repo
- Email SMTP credentials if using notification

The Jenkins EC2 instance uses IAM for EKS API calls. Docker Hub push uses the `dockerhub-jaipalreddyg` Jenkins credential.

## 7. Update Jenkinsfile

Replace:

- `jaipalreddyg/sample-app`
- `REPLACE_WITH_EMAIL`

Commit the Jenkinsfile into your application repository.

## 8. Install Monitoring

```powershell
.\scripts\install-monitoring.ps1
kubectl -n monitoring get pods
```

Access Grafana locally:

```powershell
kubectl -n monitoring port-forward svc/grafana 3000:80
```

Open:

```text
http://localhost:3000
```

## 9. Deploy Application

Run the Jenkins pipeline.

Validate:

```powershell
kubectl -n netflix get pods
kubectl -n netflix get svc
kubectl -n netflix get ingress
```

## 10. Teardown

```powershell
.\scripts\destroy.ps1
```
