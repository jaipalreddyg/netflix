$ErrorActionPreference = "Stop"

Write-Host "Deleting Kubernetes workloads..."
kubectl delete namespace netflix --ignore-not-found
kubectl delete namespace monitoring --ignore-not-found

Write-Host "Destroying Terraform infrastructure..."
Push-Location terraform/envs/dev
terraform destroy
Pop-Location
