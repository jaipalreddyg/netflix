#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="${AWS_REGION:-ap-south-1}"
CLUSTER_NAME="${CLUSTER_NAME:-$(terraform -chdir=terraform output -raw cluster_name)}"
VPC_ID="$(terraform -chdir=terraform output -raw vpc_id)"
LBC_ROLE_ARN="$(terraform -chdir=terraform output -raw load_balancer_controller_role_arn)"

aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"

helm repo add eks https://aws.github.io/eks-charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system --set args[0]=--kubelet-preferred-address-types=InternalIP \
  --atomic --wait --timeout 10m

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName="$CLUSTER_NAME" \
  --set region="$AWS_REGION" \
  --set vpcId="$VPC_ID" \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set-string "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn=$LBC_ROLE_ARN" \
  --atomic --wait --timeout 10m

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set grafana.service.type=ClusterIP \
  --set prometheus.service.type=ClusterIP \
  --set alertmanager.service.type=ClusterIP \
  --set prometheus.prometheusSpec.retention=15d \
  --atomic --wait --timeout 15m

helm upgrade --install fluent-bit fluent/fluent-bit \
  --namespace logging --create-namespace \
  --set kind=DaemonSet \
  --atomic --wait --timeout 10m

kubectl get pods -A
