# CoreDNS

## What It Does

CoreDNS resolves Kubernetes service names and external DNS queries for pods. Many application failures that look like connection issues are actually DNS lookup failures or latency spikes.

## What Breaks At Scale

- Too many DNS queries.
- Low cache hit rate.
- Slow upstream resolver.
- Too few CoreDNS replicas.
- Bad client retry behavior.
- Node-level connection tracking pressure.

## Symptoms

- Intermittent service discovery failures.
- `SERVFAIL` or timeout errors.
- Application connection failures with healthy pods/services.
- CoreDNS CPU saturation or restarts.

## Metrics, Logs, And Events

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system deployment/coredns
kubectl top pods -n kube-system
kubectl describe deployment -n kube-system coredns
```

If metrics are enabled, check CoreDNS QPS, latency, cache hit rate, and error rate.

## Typical Fixes

- Scale CoreDNS replicas.
- Tune cache behavior.
- Add NodeLocal DNSCache.
- Reduce noisy clients and retry storms.
- Review upstream resolver latency.

## Tradeoffs

More CoreDNS replicas can help throughput, but bad query patterns may still overload upstream DNS or node networking limits.

## Experiments

```bash
kubectl apply -f dns-load.yaml
kubectl logs job/dns-load
kubectl delete -f dns-load.yaml
```
