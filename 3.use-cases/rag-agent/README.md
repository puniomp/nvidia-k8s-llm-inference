# RAG Agent

Minimal placeholder API for wiring an application layer into guardrails and inference serving.

This will become the use-case layer for testing how retrieval, tool use, guardrails, and model serving interact under load.

## Current State

- `/health` endpoint
- placeholder response path

## Next Steps

- Add a small retrieval corpus
- Add a tool-call path
- Route model calls through Triton or NIM-style endpoints
- Add guardrail eval cases
