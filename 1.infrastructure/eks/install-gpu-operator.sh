#!/usr/bin/env bash
set -euo pipefail

helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update nvidia

kubectl create namespace gpu-operator --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install gpu-operator nvidia/gpu-operator \
  --namespace gpu-operator \
  --wait

kubectl get pods -n gpu-operator
