# RunPod Execution Notes

RunPod is a practical place to validate the serving layer before moving to managed Kubernetes.

## Suggested Flow

1. Start a GPU pod with an NVIDIA Triton container.
2. Mount or copy `2.projects/triton-inference/model-repository`.
3. Start Triton with:

```bash
tritonserver --model-repository=/models
```

4. Run the benchmark harness against the HTTP or gRPC endpoint.
5. Capture latency, throughput, GPU utilization, GPU memory, image version, and GPU type.

## What To Record

- GPU type
- Driver and CUDA version
- Triton image tag
- Model format
- Batch settings
- Concurrency matrix
- p50/p95/p99 latency
- Throughput
- GPU utilization
- Observed bottlenecks
