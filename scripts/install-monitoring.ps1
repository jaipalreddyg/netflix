$ErrorActionPreference = "Stop"

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm upgrade --install prometheus prometheus-community/prometheus `
  --namespace monitoring `
  --values monitoring/prometheus-values.yaml

helm upgrade --install grafana grafana/grafana `
  --namespace monitoring `
  --values monitoring/grafana-values.yaml
