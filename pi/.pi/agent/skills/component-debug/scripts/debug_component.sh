#!/bin/bash
# Component Debug Script
# Usage: ./debug_component.sh <component> [namespace]
# Example: ./debug_component.sh longhorn

set -e

COMPONENT="${1:-}"
NAMESPACE="${2:-}"

if [[ -z "$COMPONENT" ]]; then
  echo "Usage: $0 <component> [namespace]"
  echo ""
  echo "Available components:"
  ls ~/repos/infrastructure/infrastructure-flux/components/
  exit 1
fi

# Component to namespace mapping
declare -A NS_MAP=(
  ["flux"]="flux-system"
  ["longhorn"]="longhorn-system"
  ["cert-manager"]="cert-manager"
  ["cloudnative-pg"]="cnpg-system"
  ["metallb"]="metallb-system"
  ["vault"]="vault"
  ["external-secrets"]="external-secrets"
  ["kyverno"]="kyverno"
  ["kube-prometheus-stack"]="monitoring"
)

NAMESPACE="${NAMESPACE:-${NS_MAP[$COMPONENT]:-default}}"
COMPONENT_DIR="~/repos/infrastructure/infrastructure-flux/components/$COMPONENT"

echo "=== Component Debug: $COMPONENT ==="
echo "Namespace: $NAMESPACE"
echo "Directory: $COMPONENT_DIR"
echo ""

# 1. Read local YAML files
echo "=== Step 1: Local YAML Files ==="
if [[ -d "$COMPONENT_DIR" ]]; then
  for f in "$COMPONENT_DIR"/*.yaml; do
    [[ -f "$f" ]] || continue
    echo "--- $f ---"
    cat "$f"
    echo ""
  done
else
  echo "Directory not found: $COMPONENT_DIR"
fi

echo ""
echo "=== Step 2: Cluster Resources ==="

# Flux sources
echo "--- Flux Sources ---"
flux get sources -A 2>/dev/null | grep -E "($NAMESPACE|$COMPONENT)" || echo "No matching sources"

# Flux kustomizations
echo "--- Flux Kustomizations ---"
flux get kustomizations -A 2>/dev/null | grep -E "($NAMESPACE|$COMPONENT)" || echo "No matching kustomizations"

# Flux HelmReleases
echo "--- Flux HelmReleases ---"
flux get helmreleases -A 2>/dev/null | grep "$NAMESPACE" || echo "No matching helm releases"

# Pods
echo "--- Pods in $NAMESPACE ---"
kubectl get pods -n "$NAMESPACE" 2>/dev/null || echo "Namespace not found or no pods"

echo ""
echo "=== Step 3: Events ==="
kubectl get events -n "$NAMESPACE" --sort-by='.lastTimestamp' 2>/dev/null | tail -20 || echo "No events"

echo ""
echo "=== Step 4: Test Results ==="

# Test: Pods running
RUNNING=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.phase != "Running") | .metadata.name' 2>/dev/null | wc -l || echo "0")
if [[ "$RUNNING" -eq 0 ]]; then
  echo "✅ All pods running"
else
  echo "❌ $RUNNING pods not running:"
  kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.phase != "Running") | .metadata.name' 2>/dev/null
fi

# Test: Flux kustomizations reconciled
NOT_RECONCILED=$(flux get kustomizations -A 2>/dev/null | grep -v Reconciled | tail -n +2 | wc -l || echo "0")
if [[ "$NOT_RECONCILED" -eq 0 ]]; then
  echo "✅ All kustomizations reconciled"
else
  echo "❌ $NOT_RECONCILED kustomizations not reconciled"
fi

echo ""
echo "=== Debug Complete ==="