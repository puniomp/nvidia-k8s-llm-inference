# NVIDIA GPU Operator Notes

## Purpose

The NVIDIA GPU Operator automates the Kubernetes components needed to expose GPUs to containerized workloads. It is a central signal for production Kubernetes GPU operations.

## Key Components

- NVIDIA driver management
- NVIDIA container toolkit
- Kubernetes device plugin
- GPU feature discovery
- DCGM exporter for metrics
- Optional MIG management depending on hardware and cluster setup

## Validation Flow

1. Confirm GPU nodes are present:

```bash
kubectl get nodes -L nvidia.com/gpu.present
```

2. Confirm operator pods are healthy:

```bash
kubectl get pods -n gpu-operator
```

3. Run a CUDA validation pod:

```bash
kubectl apply -f 1.infrastructure/gpu-operator/gpu-validation-pod.yaml
kubectl logs pod/gpu-validation
```

4. Confirm GPU metrics are available through DCGM exporter if installed.

## Common Failure Modes

- GPU node image does not include compatible drivers.
- Container runtime is not configured for NVIDIA runtime.
- Pod requests no GPU resource, so it lands on a CPU-only node.
- Node taints prevent scheduling.
- Driver, CUDA, and container image versions are incompatible.
