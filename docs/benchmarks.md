# Benchmark Methodology

## Metrics

- Requests per second
- Tokens per second
- p50/p95/p99 latency
- Time to first token
- Inter-token latency
- Error rate
- GPU utilization
- GPU memory utilization

## Test Matrix

| Test | Concurrency | Batching | Expected Observation |
| --- | ---: | --- | --- |
| Baseline | 1 | off | Single-request latency |
| Light load | 4 | on | Queueing and batching behavior |
| Medium load | 8 | on | Throughput scaling |
| Heavy load | 16+ | on | SLO violation point |

## Notes

Keep prompts, max tokens, model version, hardware, container image, and cluster configuration fixed across runs. Record failures and timeouts instead of only reporting successful requests.
