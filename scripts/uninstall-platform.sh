#!/usr/bin/env bash
set -euo pipefail

helm -n logging uninstall fluent-bit || true
helm -n monitoring uninstall kube-prometheus-stack || true
helm -n kube-system uninstall aws-load-balancer-controller || true
helm -n kube-system uninstall metrics-server || true

