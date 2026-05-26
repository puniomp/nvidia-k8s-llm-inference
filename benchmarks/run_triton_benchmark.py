#!/usr/bin/env python3
"""Starter benchmark runner for Triton-style inference endpoints.

This file is intentionally lightweight so it can be replaced by, or imported
into, an existing LLM inference benchmark harness.
"""

from __future__ import annotations

import argparse
import statistics
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass


@dataclass
class Result:
    concurrency: int
    requests: int
    latency_ms: list[float]
    errors: int

    @property
    def p50(self) -> float:
        return percentile(self.latency_ms, 50)

    @property
    def p95(self) -> float:
        return percentile(self.latency_ms, 95)

    @property
    def p99(self) -> float:
        return percentile(self.latency_ms, 99)

    @property
    def rps(self) -> float:
        total_seconds = sum(self.latency_ms) / 1000
        if total_seconds == 0:
            return 0
        return self.requests / total_seconds


def percentile(values: list[float], pct: int) -> float:
    if not values:
        return 0
    sorted_values = sorted(values)
    index = round((pct / 100) * (len(sorted_values) - 1))
    return sorted_values[index]


def invoke_placeholder(url: str, model: str) -> None:
    """Replace with Triton HTTP/gRPC client invocation."""
    _ = (url, model)
    time.sleep(0.025)


def run_case(url: str, model: str, concurrency: int, requests: int) -> Result:
    latencies: list[float] = []
    errors = 0

    def one_request() -> float:
        start = time.perf_counter()
        invoke_placeholder(url, model)
        return (time.perf_counter() - start) * 1000

    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        futures = [executor.submit(one_request) for _ in range(requests)]
        for future in as_completed(futures):
            try:
                latencies.append(future.result())
            except Exception:
                errors += 1

    return Result(concurrency=concurrency, requests=requests, latency_ms=latencies, errors=errors)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default="localhost:8001")
    parser.add_argument("--model", default="identity")
    parser.add_argument("--concurrency", default="1,4,8,16")
    parser.add_argument("--requests", type=int, default=100)
    args = parser.parse_args()

    concurrencies = [int(item.strip()) for item in args.concurrency.split(",")]
    print("concurrency,requests,p50_ms,p95_ms,p99_ms,errors")
    for concurrency in concurrencies:
        result = run_case(args.url, args.model, concurrency, args.requests)
        print(
            f"{result.concurrency},{result.requests},"
            f"{result.p50:.2f},{result.p95:.2f},{result.p99:.2f},{result.errors}"
        )


if __name__ == "__main__":
    main()
