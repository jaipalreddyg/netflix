# Runbook

## Check Jenkins

```bash
sudo systemctl status jenkins
sudo journalctl -u jenkins -n 100 --no-pager
```

## Check Docker

```bash
sudo systemctl status docker
docker ps
```

## Check EKS

```powershell
kubectl get nodes
kubectl -n netflix get all
kubectl -n netflix describe deployment netflix-clone
```

## Roll Back Application

```powershell
kubectl -n netflix rollout history deployment/netflix-clone
kubectl -n netflix rollout undo deployment/netflix-clone
```

## Check Monitoring

```powershell
kubectl -n monitoring get pods
kubectl -n monitoring port-forward svc/grafana 3000:80
```

## Common Fixes

- If image pull fails, confirm the Docker Hub repository `jaipalreddyg/sample-app` and image tag.
- If Jenkins cannot push to Docker Hub, check the `dockerhub-jaipalreddyg` Jenkins credential and Docker Hub token permissions.
- If Jenkins cannot deploy to EKS, map the Jenkins IAM role into cluster access.
- If Ingress has no address, install AWS Load Balancer Controller.
