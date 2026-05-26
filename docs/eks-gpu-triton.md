# EKS GPU Triton Runbook

This runbook validates the first end-to-end path:

```text
EKS GPU node -> NVIDIA GPU Operator -> Triton Inference Server -> benchmark client
```

## 1. Check GPU Quota

Run the preflight script first:

```bash
bash 1.infrastructure/eks/preflight.sh
```

For the default `g4dn.xlarge`, check G instance quota in the target region:

```bash
aws service-quotas list-service-quotas \
  --service-code ec2 \
  --query "Quotas[?contains(QuotaName, 'Running On-Demand G')].[QuotaName,Value]" \
  --output table
```

The default config uses one `g4dn.xlarge`, which requires 4 vCPUs of On-Demand G/VT instance quota.

## 2. Create EKS Cluster

```bash
eksctl create cluster -f 1.infrastructure/eks/cluster.yaml
```

## 3. Install NVIDIA GPU Operator

```bash
bash 1.infrastructure/eks/install-gpu-operator.sh
```

Wait for pods to become ready:

```bash
kubectl get pods -n gpu-operator
```

## 4. Validate GPU Access

```bash
kubectl apply -f 1.infrastructure/gpu-operator/gpu-validation-pod.yaml
kubectl logs pod/gpu-validation
```

Save the output in your notes. It should show the GPU visible inside the pod.

## 5. Deploy Triton Identity Model

```bash
kubectl apply -f 1.infrastructure/triton/model-config/identity-configmap.yaml
kubectl apply -f 1.infrastructure/triton/
kubectl rollout status deployment/triton-inference-server
```

Check health:

```bash
kubectl port-forward svc/triton 8000:8000 8001:8001 8002:8002
curl localhost:8000/v2/health/ready
```

## 6. Run Benchmark

In another terminal:

```bash
python benchmarks/run_triton_benchmark.py \
  --url localhost:8001 \
  --model identity \
  --concurrency 1,4,8,16 \
  --requests 100
```

Save results under:

```text
benchmarks/results/
```

## 7. Clean Up

Delete the cluster when finished:

```bash
bash 1.infrastructure/eks/delete-cluster.sh
```

Confirm no cluster remains:

```bash
eksctl get cluster
```
