# NeMo Guardrails

Starter configuration for adding a policy layer around a RAG or agent workflow.

This project is intentionally small until the application path is wired in. The goal is to keep guardrails testable with a compact set of prompts before adding more complex tool-use or retrieval behavior.

## Contents

```text
config.yml
rails.co
```

## What To Test

- Supported topic handling
- Out-of-scope request behavior
- PII or sensitive-data handling
- Tool-call restrictions for agent workflows
- Regression prompts for expected refusal or redirect behavior

## Kubernetes Deployment

The Kubernetes manifests live under:

```text
1.infrastructure/nemo-guardrails/
```
