# Node Pressure

## What It Does

Kubelet manages pod lifecycle on each worker node. It pulls images, starts containers through the runtime, sends heartbeats, reports node conditions, and evicts pods when local resources become constrained.

## What Breaks At Scale

- Large images slow down rollout and recovery.
- Disk pressure triggers image garbage collection or pod eviction.
- Memory pressure triggers pod eviction based on QoS class.
- CPU limits can cause throttling and misleading application latency.
- Runtime latency can make a healthy control plane look slow from the workload perspective.

## Symptoms

- Pods stuck in `ContainerCreating` or `ImagePullBackOff`.
- Node condition changes: `MemoryPressure`, `DiskPressure`, `PIDPressure`, `Ready=False`.
- Eviction events.
- Slow rollouts even when nodes have allocatable capacity.

## Metrics, Logs, And Events

```bash
kubectl describe pod <pod>
kubectl describe node <node>
kubectl get events --sort-by=.lastTimestamp
kubectl top nodes
kubectl top pods
```

On a managed node, cloud logs or node access may be needed for kubelet/runtime logs.

## Typical Fixes

- Use smaller images and image pre-pull strategies.
- Set realistic requests and limits.
- Separate bursty workloads from latency-sensitive inference.
- Monitor node filesystem and image cache.
- Use rollout strategies that account for image pull time.

## Tradeoffs

Higher limits reduce throttling risk but can lower bin-packing efficiency. Smaller images improve rollout speed but require more disciplined build pipelines.

## Experiments

```bash
kubectl apply -f huge-image-pull.yaml
kubectl describe pod huge-image-pull
kubectl delete -f huge-image-pull.yaml
```
