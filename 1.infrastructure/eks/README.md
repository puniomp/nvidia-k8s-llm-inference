# EKS GPU Cluster

Minimal EKS setup for running NVIDIA GPU inference examples.

The default config creates:

- One EKS cluster in `us-east-1`
- One managed GPU node group using `g4dn.xlarge`
- No application `LoadBalancer` services
- ClusterIP services accessed through `kubectl port-forward`

## Prerequisites

- AWS CLI authenticated to the target account
- `eksctl`
- `kubectl`
- `helm`
- EC2 GPU quota for `g4dn.xlarge` or another GPU instance family

## Create Cluster

Run preflight checks:

```bash
bash 1.infrastructure/eks/preflight.sh
```

Create the cluster:

```bash
eksctl create cluster -f 1.infrastructure/eks/cluster.yaml
```

## Install GPU Operator

```bash
bash 1.infrastructure/eks/install-gpu-operator.sh
```

## Validate GPU Access

```bash
kubectl apply -f 1.infrastructure/gpu-operator/gpu-validation-pod.yaml
kubectl logs pod/gpu-validation
```

Expected output should include `nvidia-smi` output from the GPU node.

## Delete Cluster

```bash
bash 1.infrastructure/eks/delete-cluster.sh
```

Do not leave the cluster running after benchmarking.
