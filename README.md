# NVIDIA Kubernetes LLM Inference

Reference architectures and test cases for running LLM inference workloads on Kubernetes with NVIDIA GPU software.

This repository collects infrastructure setup, serving examples, and use-case patterns for GPU-backed inference. It focuses on practical deployment paths for NVIDIA GPU Operator, Triton Inference Server, NIM-style endpoints, NeMo Guardrails, and TensorRT-LLM optimization concepts.

The goal is to provide end-to-end setups that make inference behavior easier to test, benchmark, and reason about on Kubernetes.

## Scope

- Kubernetes GPU readiness with NVIDIA GPU Operator
- Triton Inference Server deployment and dynamic batching behavior
- NIM-style serving patterns for model endpoints
- NeMo Guardrails as a policy layer for RAG and agent workflows
- Latency, throughput, TTFT, inter-token latency, batching, and GPU utilization under load
- Where TensorRT-LLM changes the serving tradeoffs

## Architecture

```text
Client / Benchmark Harness
        |
        v
RAG or Agent API
        |
        +--> NeMo Guardrails policy layer
        |
        +--> Retrieval / enterprise tools
        |
        v
Inference Endpoint
        |
        +--> Triton Inference Server
        +--> NIM-compatible endpoint pattern
        |
        v
Kubernetes GPU Node Pool
        |
        +--> NVIDIA GPU Operator
        +--> Device plugin
        +--> Container runtime integration
        +--> GPU metrics
```

## Repository Layout

```text
1.infrastructure/
  eks/                 EKS GPU cluster setup
  gpu-operator/        GPU Operator validation workloads
  nemo-guardrails/     Guardrails deployment manifests
  rag-agent/           App deployment manifests
  triton/              Triton deployment manifests
2.projects/
  nemo-guardrails/     NeMo Guardrails starter configuration
  triton-inference/    Example Triton model repository
3.use-cases/
  rag-agent/           Small RAG or tool-using agent app
4.operations/
  scheduling/          Pending pods, requests, taints, tolerations, GPU allocatable capacity
  node-pressure/       Image pulls, node conditions, kubelet/node symptoms
  coredns/             DNS load and service discovery failure modes
  autoscaling/         HPA and node provisioning feedback loops
  disruption/          PDB and node drain behavior
  observability/       Commands for events, pods, nodes, metrics, and rollout triage
benchmarks/
  results/             Benchmark output tables and notes
docs/
  eks-gpu-triton.md    EKS GPU Operator and Triton runbook
  gpu-operator.md      GPU Operator install and validation notes
  runpod.md            Notes for quick GPU experiments
  benchmarks.md        Benchmark methodology
```

## Quick Start

Each layer can be tested independently before combining the full path.

Before creating the EKS cluster, run the preflight check:

```bash
bash 1.infrastructure/eks/preflight.sh
```

The default EKS config uses one `g4dn.xlarge` GPU node in `us-east-1`. This requires at least `4` vCPUs of EC2 **Running On-Demand G and VT instances** quota in that region. If the quota is `0`, request an increase before creating the cluster.

1. Create an EKS GPU cluster:

```bash
eksctl create cluster -f 1.infrastructure/eks/cluster.yaml
```

2. Install NVIDIA GPU Operator:

```bash
bash 1.infrastructure/eks/install-gpu-operator.sh
```

3. Validate Kubernetes GPU access:

```bash
kubectl apply -f 1.infrastructure/gpu-operator/gpu-validation-pod.yaml
kubectl logs pod/gpu-validation
```

4. Deploy Triton:

```bash
kubectl apply -f 1.infrastructure/triton/model-config/identity-configmap.yaml
kubectl apply -f 1.infrastructure/triton/
```

5. Run benchmark client:

```bash
python benchmarks/run_triton_benchmark.py --url localhost:8001 --model identity --concurrency 1,4,8,16
```

6. Add NeMo Guardrails around the RAG/agent API:

```bash
kubectl apply -f 1.infrastructure/nemo-guardrails/
```

## Infrastructure

The `1.infrastructure/` directory contains Kubernetes manifests for validating GPU access and deploying the serving/application components used by the examples.

Start with the EKS runbook:

```bash
docs/eks-gpu-triton.md
```

## Projects

### Triton Inference

`2.projects/triton-inference/` contains a starter Triton model repository with a Python backend identity model and dynamic batching configuration. It is intentionally small so the serving path, health checks, and benchmark wiring can be validated before replacing it with a larger model.

### NeMo Guardrails

`2.projects/nemo-guardrails/` contains a starter guardrails configuration for adding policy controls around RAG or agent workflows.

## Use Cases

### RAG Agent

`3.use-cases/rag-agent/` contains a minimal placeholder API for wiring an application layer into the guardrails and inference path.

## Kubernetes Operations

`4.operations/` contains focused failure-mode experiments for the Kubernetes internals behind GPU inference workloads. These cover scheduling, node pressure, CoreDNS, autoscaling, disruption controls, and observability.

Each topic follows the same shape:

- what the component does
- what breaks at scale
- symptoms
- metrics, logs, and events to inspect
- typical fixes
- tradeoffs

## Roadmap

Planned additions:

- Run GPU Operator validation on EKS with a GPU-backed node group
- Add a real Triton model repository using ONNX or TensorRT plan format
- Integrate the benchmark harness with Triton gRPC/HTTP clients
- Add NeMo Guardrails runtime examples and eval cases
- Capture benchmark results from a RunPod, AKS GPU, or other cloud GPU environment
