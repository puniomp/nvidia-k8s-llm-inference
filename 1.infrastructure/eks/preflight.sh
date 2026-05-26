#!/usr/bin/env bash
set -euo pipefail

for cmd in aws eksctl kubectl helm; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
done

echo "AWS account:"
aws sts get-caller-identity --query '{Account:Account,Arn:Arn}' --output table

echo
echo "EKS config:"
eksctl version
kubectl version --client=true
helm version --short

echo
echo "Checking EC2 On-Demand G/VT quota:"
aws service-quotas list-service-quotas \
  --service-code ec2 \
  --query "Quotas[?contains(QuotaName, 'Running On-Demand G') || contains(QuotaName, 'Running On-Demand VT')].[QuotaName,Value]" \
  --output table

echo
echo "Default cluster config uses g4dn.xlarge in us-east-1."
echo "You need at least 4 vCPUs of On-Demand G/VT quota for one node."
