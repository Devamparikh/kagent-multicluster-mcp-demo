# Demo Flow

This demo shows a safe adoption path for agentic Kubernetes operations.

The goal is not to give an AI agent unrestricted cluster access. The goal is to expose a small, reviewable, read-only operational surface that can help an on-call engineer move faster during triage.

## Scenario

An alert arrives in Slack or Microsoft Teams:

```text
Alert: checkout-api p95 latency is above 2s
Scope: production
Signal: error rate increased after rollout
```

The incident responder asks:

```text
Compare checkout-api health in cluster-a and cluster-b.
List pods, events, rollout status, and any obvious Kubernetes errors.
Do not change anything.
```

## Expected agent path

1. The chat integration sends the request to Kagent.
2. Kagent selects tools from the configured `RemoteMCPServer`.
3. The remote MCP server points at Agentgateway.
4. Agentgateway exposes a Virtual MCP endpoint with cluster-prefixed tools.
5. The agent calls `cluster-a_*` tools for cluster A.
6. The agent calls `cluster-b_*` tools for cluster B.
7. The final response includes evidence, not guesses.

## Example response shape

```text
I inspected checkout-api in cluster-a and cluster-b.

cluster-a:
- Deployment rollout is complete.
- Pods are Ready.
- No new warning events found.

cluster-b:
- Two pods are CrashLoopBackOff.
- Recent events show failed readiness probes.
- The latest ReplicaSet was created 12 minutes before the alert.

Likely next step:
- Inspect application logs for the failing pods in cluster-b.
- This may include sensitive data, so I need approval before fetching logs.
```

## Why this matters

The agent should be useful before it is powerful.

Read-only triage can reduce the time spent collecting context while keeping the blast radius small. Write actions can come later, with stronger controls and human approval.
