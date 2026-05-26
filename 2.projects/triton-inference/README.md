# Triton Inference

This project contains a small Triton Inference Server model repository and Kubernetes deployment path for validating GPU-backed serving behavior.

The first model is intentionally simple: a Python backend identity model with dynamic batching enabled. This keeps the serving path easy to inspect before swapping in a larger ONNX, TensorRT, or LLM backend model.

## Contents

```text
model-repository/
  identity/
    config.pbtxt
    1/
      model.py
```

## What To Test

- Triton container startup on a GPU node
- Model repository loading
- Dynamic batching configuration
- HTTP/gRPC endpoint health
- Concurrency and latency behavior through the benchmark harness

## Kubernetes Deployment

The Kubernetes manifests live under:

```text
1.infrastructure/triton/
```

Deploy with:

```bash
kubectl apply -f 1.infrastructure/triton/model-config/identity-configmap.yaml
kubectl apply -f 1.infrastructure/triton/
```

For local testing:

```bash
kubectl port-forward svc/triton 8000:8000 8001:8001 8002:8002
```

## Next Steps

- Mount the model repository into the Triton pod
- Replace the identity model with an ONNX or TensorRT model
- Add a Triton client path to `benchmarks/run_triton_benchmark.py`
- Capture p50/p95/p99 latency, throughput, and GPU utilization under concurrency
