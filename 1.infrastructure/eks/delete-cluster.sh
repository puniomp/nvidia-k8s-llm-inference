#!/usr/bin/env bash
set -euo pipefail

eksctl delete cluster -f 1.infrastructure/eks/cluster.yaml --wait
