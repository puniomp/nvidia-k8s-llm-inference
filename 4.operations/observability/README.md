# Observability Commands

Common commands for triaging Kubernetes scheduling, node, networking, autoscaling, and rollout behavior.

## Events

```bash
kubectl get events --sort-by=.lastTimestamp
kubectl get events -A --sort-by=.lastTimestamp
```

## Pods

```bash
kubectl get pods -A -o wide
kubectl describe pod <pod>
kubectl logs <pod>
kubectl logs deployment/<deployment>
```

## Nodes

```bash
kubectl get nodes -o wide
kubectl describe node <node>
kubectl top nodes
```

## Workloads

```bash
kubectl get deploy,sts,ds -A
kubectl rollout status deployment/<deployment>
kubectl describe deployment <deployment>
```

## Scheduling

```bash
kubectl get pods --field-selector=status.phase=Pending -A
kubectl describe pod <pending-pod>
kubectl get nodes --show-labels
kubectl describe node <node>
```

## Autoscaling

```bash
kubectl get hpa -A
kubectl describe hpa <hpa>
kubectl top pods -A
```

## DNS

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system deployment/coredns
kubectl exec -it <pod> -- nslookup kubernetes.default.svc.cluster.local
```

## GPU

```bash
kubectl describe node <gpu-node>
kubectl get pods -A -o wide | grep -i gpu
kubectl logs pod/gpu-validation
```
