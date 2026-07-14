#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "docs/demo-flow.md"
  "docs/guardrails.md"
  "docs/talk-abstract.md"
  "manifests/agentgateway/agentgateway-backend.yaml"
  "manifests/agentgateway/http-route.yaml"
  "manifests/kagent/remote-mcp-server.yaml"
  "manifests/kagent/agent-readonly.yaml"
  "manifests/mcp-servers/kubernetes-mcp-rbac.yaml"
  "manifests/policies/tool-risk-policy.example.yaml"
  "manifests/kustomization.yaml"
)

echo "Checking demo repository files..."
for file in "${required_files[@]}"; do
  if [[ ! -f "${ROOT_DIR}/${file}" ]]; then
    echo "Missing required file: ${file}" >&2
    exit 1
  fi
  echo "ok: ${file}"
done

echo
echo "Checking tool prefixes..."
grep -R "cluster-a_" "${ROOT_DIR}/manifests" >/dev/null
grep -R "cluster-b_" "${ROOT_DIR}/manifests" >/dev/null
echo "ok: cluster-a and cluster-b tool prefixes are present"

echo
echo "Checking that the sample agent is read-only..."
if grep -R "delete\\|patch\\|scale\\|rollout\\|create" "${ROOT_DIR}/manifests/kagent/agent-readonly.yaml" >/dev/null; then
  echo "Unexpected mutating tool reference in read-only agent" >&2
  exit 1
fi
echo "ok: no mutating tool names in read-only agent"

echo
echo "Real environment verification flow:"
cat <<'EOF'
1. Confirm each application-cluster MCP endpoint responds directly.
2. Confirm AgentgatewayBackend is accepted.
3. Confirm HTTPRoute resolves the AgentgatewayBackend.
4. List tools through the federated MCP endpoint.
5. Confirm cluster-a_* and cluster-b_* tools are present.
6. Confirm Kagent RemoteMCPServer discovers the federated endpoint.
7. Ask the Kagent agent to compare one workload across both clusters.
8. Verify the agent cites Kubernetes evidence and does not mutate resources.
EOF

echo
echo "Demo static verification complete."
