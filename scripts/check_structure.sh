#!/usr/bin/env bash
set -euo pipefail

test -f README.md
test -f docs/gpu-operator.md
test -f docs/eks-gpu-triton.md
test -f docs/runpod.md
test -f docs/benchmarks.md
test -f 1.infrastructure/eks/cluster.yaml
test -x 1.infrastructure/eks/preflight.sh
test -x 1.infrastructure/eks/install-gpu-operator.sh
test -x 1.infrastructure/eks/delete-cluster.sh
test -f 1.infrastructure/gpu-operator/gpu-validation-pod.yaml
test -f 1.infrastructure/triton/deployment.yaml
test -f 1.infrastructure/triton/model-config/identity-configmap.yaml
test -f 2.projects/triton-inference/README.md
test -f 2.projects/triton-inference/model-repository/identity/config.pbtxt
test -f 2.projects/nemo-guardrails/README.md
test -f 3.use-cases/rag-agent/README.md
test -f benchmarks/run_triton_benchmark.py

echo "Repository structure looks good."
