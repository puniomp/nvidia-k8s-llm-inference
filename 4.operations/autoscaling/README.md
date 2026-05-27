# Autoscaling

## What It Does

Kubernetes autoscaling is a set of feedback loops:

- HPA changes pod replica count.
- VPA adjusts pod requests.
- Cluster Autoscaler or Karpenter adds and removes nodes.

For GPU workloads, pod autoscaling can be limited by node provisioning latency and scarce GPU capacity.

## What Breaks At Scale

- HPA adds pods, but they remain pending because no GPU node has capacity.
- Node provisioning takes longer than the application latency budget.
- Image pull and readiness delay extend time to serve.
- Scale-down disrupts workloads without enough disruption controls.
- GPU nodes are expensive when overprovisioned.

## Symptoms

- HPA desired replicas increase while pods remain pending.
- Events show `Insufficient nvidia.com/gpu`.
- p95 latency spikes before capacity catches up.
- Cluster Autoscaler events show scale-up attempts or failures.

## Metrics, Logs, And Events

```bash
kubectl get hpa
kubectl describe hpa <name>
kubectl get pods -o wide
kubectl describe pod <pending-pod>
kubectl get events --sort-by=.lastTimestamp
```

For EKS, also inspect Cluster Autoscaler or Karpenter logs if installed.

## Typical Fixes

- Keep warm capacity for latency-sensitive workloads.
- Use overprovisioning pods for faster scheduling.
- Reduce image size and startup time.
- Use right-sized requests.
- Separate GPU node pools by workload class.

## Tradeoffs

Warm GPU capacity reduces latency risk but increases idle cost. Aggressive scale-to-zero reduces cost but adds cold-start delay.

## Experiments

```bash
kubectl apply -f cpu-hpa-demo.yaml
kubectl get hpa
kubectl delete -f cpu-hpa-demo.yaml
```
