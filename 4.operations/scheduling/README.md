# Scheduling

## What It Does

The scheduler assigns pending pods to nodes by evaluating resource requests, node allocatable capacity, taints, tolerations, node selectors, affinity, topology spread, and priority.

For GPU inference, the scheduler must find a node with available `nvidia.com/gpu` capacity and any required tolerations or labels.

## What Breaks At Scale

- Inflated CPU or memory requests reduce bin-packing efficiency.
- Missing tolerations prevent workloads from landing on dedicated GPU nodes.
- GPU pods stay pending when no node has available `nvidia.com/gpu`.
- Topology or affinity constraints make capacity unusable.
- Cluster autoscaling may lag behind workload demand.

## Symptoms

- Pods remain `Pending`.
- Events show `Insufficient cpu`, `Insufficient memory`, or `Insufficient nvidia.com/gpu`.
- GPU nodes appear idle while pods cannot schedule due to taints or labels.

## Metrics, Logs, And Events

```bash
kubectl describe pod <pod>
kubectl get events --sort-by=.lastTimestamp
kubectl describe node <node>
kubectl get nodes -o wide
kubectl get pods -A -o wide
```

## Typical Fixes

- Right-size requests.
- Add node selectors, tolerations, or affinity intentionally.
- Add GPU capacity.
- Use priority classes for critical workloads.
- Use topology spread constraints carefully.

## Tradeoffs

Strict scheduling constraints improve isolation but can strand capacity. Loose constraints improve utilization but increase noisy-neighbor risk.

## Experiments

```bash
kubectl apply -f inflated-requests.yaml
kubectl describe pod inflated-requests
kubectl delete -f inflated-requests.yaml
```

```bash
kubectl apply -f gpu-pending-pod.yaml
kubectl describe pod gpu-pending
kubectl delete -f gpu-pending-pod.yaml
```
