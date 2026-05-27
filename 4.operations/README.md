# Kubernetes Operations

Failure-mode experiments for understanding how Kubernetes behaves under scheduling pressure, node pressure, DNS load, autoscaling lag, and disruption controls.

The inference examples in this repository focus on NVIDIA GPU serving. This section focuses on the operational substrate underneath those workloads: what breaks, how it shows up, what to inspect, and how to design around it.

## Experiments

```text
scheduling/      Pending pods, requests, taints, tolerations, GPU allocatable capacity
node-pressure/   Image pulls, memory pressure, eviction behavior, kubelet/node symptoms
coredns/         DNS load, CoreDNS saturation, service discovery failures
autoscaling/     HPA vs node provisioning feedback loops
disruption/      PodDisruptionBudgets and node drain behavior
observability/   Commands for events, pods, nodes, metrics, and rollout triage
```

## Study Template

Each topic follows the same structure:

- What it does
- What breaks at scale
- Symptoms
- Metrics, logs, and events to check
- Typical fixes
- Tradeoffs
