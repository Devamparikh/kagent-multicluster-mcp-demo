# CFP Draft

## Title

Building a Private-by-Design Agentic AI Platform for Kubernetes Incident Triage

## Abstract

Kubernetes incident response usually starts with context gathering: which cluster is impacted, what changed, which pods are unhealthy, what do events say, and whether the latest rollout is related. In multi-cluster environments, that context is often spread across application clusters, management clusters, dashboards, chat channels, and runbooks.

This session presents a practical architecture for agent-assisted Kubernetes triage using Kagent, Agentgateway, and MCP. We will look at how a platform team can expose read-only Kubernetes MCP tools from multiple application clusters, federate them through Agentgateway Virtual MCP, and connect the resulting endpoint to a Kagent agent that can be called from incident workflows such as Slack or Microsoft Teams.

The focus is safety, not hype. The talk will cover cluster-prefixed tools, read-only-first adoption, human approval for risky actions, why `pods/exec` should be treated as secret-adjacent, and how organizations can keep operational data inside their own boundary by choosing private or self-hosted model deployments.

Attendees will leave with a concrete platform pattern for agentic Kubernetes operations: one agent-facing endpoint, many cluster-local tools, clear guardrails, and a path from assisted triage toward safer automated remediation.

## Benefits to the ecosystem

This talk helps platform engineers, SREs, and cloud native practitioners evaluate agentic operations through Kubernetes-native primitives instead of product demos. It shows how open source projects such as Kagent, Agentgateway, MCP, Kubernetes, and Gateway API can be combined into a governed operational workflow.

The session contributes a practical, vendor-neutral pattern for the cloud native ecosystem: start read-only, keep boundaries explicit, use policy and approval before mutation, and design for organizations that cannot send incident data outside their trust boundary.

## Open source projects used

- Kubernetes
- Kagent
- Agentgateway
- Model Context Protocol (MCP)
- Gateway API
- Argo CD or GitOps tooling for deployment workflows
- Optional: Slack or Microsoft Teams integrations

## Audience

Intermediate platform engineers, SREs, DevOps engineers, Kubernetes operators, and engineering leaders exploring practical AI-assisted operations.
