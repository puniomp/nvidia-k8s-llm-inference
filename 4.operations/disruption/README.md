# Disruption

## What It Does

PodDisruptionBudgets control how many pods for an application can be voluntarily disrupted during operations such as node drains and upgrades.

## What Breaks At Scale

- Strict PDBs block node drains.
- Single-replica workloads with `minAvailable: 1` cannot be evicted voluntarily.
- Upgrades stall because workloads have no spare capacity.
- Topology constraints and PDBs interact in surprising ways.

## Symptoms

- `kubectl drain` hangs or fails.
- Events show eviction blocked by PDB.
- Managed node group upgrades stall.
- Nodes remain in draining state.

## Metrics, Logs, And Events

```bash
kubectl get pdb
kubectl describe pdb <pdb>
kubectl drain <node> --ignore-daemonsets --dry-run=server
kubectl get events --sort-by=.lastTimestamp
```

## Typical Fixes

- Use at least two replicas for workloads protected by PDBs.
- Add surge capacity before upgrades.
- Make PDBs match operational reality.
- Use topology spread so replicas are not concentrated on one node.

## Tradeoffs

Strict PDBs protect availability but can block maintenance. Relaxed PDBs improve operability but increase disruption risk.

## Experiments

```bash
kubectl apply -f pdb-blocking-drain.yaml
kubectl get pdb
kubectl delete -f pdb-blocking-drain.yaml
```
