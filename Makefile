.PHONY: check benchmark

check:
	bash scripts/check_structure.sh
	PYTHONPYCACHEPREFIX=.pycache python3 -m py_compile benchmarks/run_triton_benchmark.py 3.use-cases/rag-agent/app.py

benchmark:
	python3 benchmarks/run_triton_benchmark.py --url localhost:8001 --model identity --concurrency 1,4,8,16
