#!/usr/bin/env bash
set -euo pipefail

kubectl auth can-i get deployments -n sample-app
kubectl -n sample-app rollout status deployment/sample-app --timeout=5m
kubectl -n sample-app wait --for=condition=Ready pod \
  -l app.kubernetes.io/name=sample-app --timeout=5m
kubectl -n sample-app get deployment,pod,service,ingress,hpa,pdb

READY="$(kubectl -n sample-app get deployment sample-app -o jsonpath='{.status.readyReplicas}')"
if [[ "${READY:-0}" -lt 3 ]]; then
  echo "Expected at least 3 ready replicas, found ${READY:-0}" >&2
  exit 1
fi

kubectl -n sample-app run validation-curl \
  --image=curlimages/curl:8.16.0 --restart=Never --rm -i \
  -- curl -fsS --retry 10 --retry-delay 5 http://sample-app/

helm -n default test sample-app --logs || true

