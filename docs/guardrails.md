# Guardrails

Agentic Kubernetes operations need guardrails before write access.

This demo uses a simple risk model that can be implemented with prompts, RBAC, policy engines, approval workflows, or a combination of those controls.

## Risk levels

| Level | Description | Examples | Default behavior |
| --- | --- | --- | --- |
| Green | Low-risk read-only inspection | list pods, get deployment, describe pod, list events | Allow |
| Yellow | Sensitive or ambiguous read actions | logs, exec for read-only commands, reading environment variables | Ask for approval |
| Red | Mutating or high-impact actions | delete pod, patch deployment, scale workload, rollout undo, read secrets | Block or ask for explicit approval |

## Why `pods/exec` is sensitive

`pods/exec` often looks like a troubleshooting command, but it can cross important boundaries:

- It may expose environment variables.
- It may read mounted files.
- It may bypass application-level authorization.
- It may reveal credentials, tokens, or internal service topology.

Treat exec as secret-adjacent. Enable it only when the organization has approval, audit, and scope controls in place.

## Suggested controls

- Start with read-only Kubernetes RBAC.
- Use namespace-scoped service accounts for MCP servers.
- Keep write-capable tools out of the default agent.
- Use explicit tool allowlists in Kagent.
- Require human approval for Yellow and Red actions.
- Log tool calls, prompts, and approvals.
- Redact secrets and tokens from tool responses.
- Keep cluster and tenant boundaries visible in tool names.

## Prompt boundary

The agent system prompt should be boring and direct:

```text
You are a read-only Kubernetes incident triage assistant.
Use only the tools listed in your configuration.
Do not perform write operations.
Do not request secrets.
If a user asks for logs, exec, mutation, or secret access, explain the risk and ask for approval.
When reporting findings, cite the Kubernetes object, namespace, cluster prefix, and tool result used as evidence.
```

Prompts are not enough by themselves. They should sit on top of RBAC, network policy, allowlists, and approval workflows.
