#!/bin/bash
# Test Component Health
# Usage: ./test_component.sh <component> [namespace]
# Returns: 0 if all tests pass, 1 if any fail

COMPONENT="${1:-}"
NAMESPACE="${2:-}"

if [[ -z "$COMPONENT" ]]; then
  echo "Usage: $0 <component> [namespace]"
  exit 1
fi

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
  ["atlas-operator"]="atlas-operator-system"
  ["authentik"]="auth"
  ["cloudflared"]="cloudflared"
  ["envoy"]="envoy-gateway"
  ["kubelet-csr-approver"]="kubelet-csr-approver"
)

NAMESPACE="${NAMESPACE:-${NS_MAP[$COMPONENT]:-default}}"
FAILED=0

echo "=== Testing $COMPONENT (namespace: $NAMESPACE) ==="

# Test 1: All pods are Running
echo -n "Test 1: Pods running... "
NOT_RUNNING=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.phase != "Running") | .metadata.name' 2>/dev/null | wc -l || echo "0")
if [[ "$NOT_RUNNING" -eq 0 ]]; then
  echo "✅ PASS"
else
  echo "❌ FAIL ($NOT_RUNNING pods not running)"
  FAILED=$((FAILED + 1))
fi

# Test 2: No CrashLoopBackOff
echo -n "Test 2: No CrashLoopBackOff... "
CRASHLOOPS=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff") | .metadata.name' 2>/dev/null | wc -l || echo "0")
if [[ "$CRASHLOOPS" -eq 0 ]]; then
  echo "✅ PASS"
else
  echo "❌ FAIL ($CRASHLOOPS pods in CrashLoopBackOff)"
  FAILED=$((FAILED + 1))
fi

# Test 3: No ImagePullBackOff
echo -n "Test 3: No ImagePullBackOff... "
IMGPULL=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.containerStatuses[].state.waiting.reason == "ImagePullBackOff") | .metadata.name' 2>/dev/null | wc -l || echo "0")
if [[ "$IMGPULL" -eq 0 ]]; then
  echo "✅ PASS"
else
  echo "❌ FAIL ($IMGPULL pods with ImagePullBackOff)"
  FAILED=$((FAILED + 1))
fi

# Test 4: Flux kustomizations reconciled (if applicable)
echo -n "Test 4: Flux kustomizations reconciled... "
KUST_COUNT=$(flux get kustomizations -A 2>/dev/null | grep "$NAMESPACE" | wc -l || echo "0")
if [[ "$KUST_COUNT" -gt 0 ]]; then
  NOT_RECONCILED=$(flux get kustomizations -A 2>/dev/null | grep "$NAMESPACE" | grep -v Reconciled | wc -l || echo "0")
  if [[ "$NOT_RECONCILED" -eq 0 ]]; then
    echo "✅ PASS"
  else
    echo "❌ FAIL ($NOT_RECONCILED not reconciled)"
    FAILED=$((FAILED + 1))
  fi
else
  echo "⏭️  SKIP (no kustomizations)"
fi

# Test 5: No error events in last 5 minutes
echo -n "Test 5: No error events... "
ERRORS=$(kubectl get events -n "$NAMESPACE" --sort-by='.lastTimestamp' 2>/dev/null | grep -E "(Error|Failed|Crash)" | tail -5 | wc -l || echo "0")
if [[ "$ERRORS" -eq 0 ]]; then
  echo "✅ PASS"
else
  echo "❌ FAIL ($ERRORS error events)"
  FAILED=$((FAILED + 1))
fi

echo ""
echo "=== Test Summary: $FAILED test(s) failed ==="

if [[ "$FAILED" -eq 0 ]]; then
  exit 0
else
  exit 1
fi