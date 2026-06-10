#!/bin/bash
# Auto-fix Common Problems
# Usage: ./fix_component.sh <component> <problem_type>
# Problem types: crashloop, imagepull, notready, dependency, drift

COMPONENT="${1:-}"
PROBLEM="${2:-}"

if [[ -z "$COMPONENT" || -z "$PROBLEM" ]]; then
  echo "Usage: $0 <component> <problem_type>"
  echo ""
  echo "Problem types:"
  echo "  crashloop  - Fix CrashLoopBackOff pods"
  echo "  imagepull  - Fix ImagePullBackOff pods"
  echo "  notready   - Fix NotReady resources"
  echo "  dependency - Fix DependencyNotReady"
  echo "  drift      - Sync drift from cluster"
  exit 1
fi

# Component namespace mapping
declare -A NS_MAP=(
  ["flux"]="flux-system"
  ["longhorn"]="longhorn-system"
  ["cert-manager"]="cert-manager"
  ["cloudnative-pg"]="cnpg-system"
  ["metallb"]="metallb-system"
  ["vault"]="vault"
  ["external-secrets"]="external-secrets"
  ["kyverno"]="kyverno"
)

NAMESPACE="${NS_MAP[$COMPONENT]:-$COMPONENT}"
COMPONENT_DIR="~/repos/infrastructure/infrastructure-flux/components/$COMPONENT"

echo "=== Fixing $PROBLEM for $COMPONENT (namespace: $NAMESPACE) ==="

case "$PROBLEM" in
  crashloop)
    echo "--- CrashLoopBackOff Fix ---"
    PODS=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff") | .metadata.name' 2>/dev/null)
    if [[ -z "$PODS" ]]; then
      echo "No CrashLoopBackOff pods found"
      exit 0
    fi
    for POD in $PODS; do
      echo "Analyzing pod: $POD"
      kubectl describe pod "$POD" -n "$NAMESPACE" | grep -A5 "Last State:"
      kubectl logs "$POD" -n "$NAMESPACE" --previous --tail=50 2>/dev/null || true
    done
    echo "Action: Check logs above for root cause. Common fixes:"
    echo "  - Increase resource limits"
    echo "  - Fix application configuration"
    echo "  - Update image version"
    ;;
    
  imagepull)
    echo "--- ImagePullBackOff Fix ---"
    PODS=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.containerStatuses[].state.waiting.reason == "ImagePullBackOff") | .metadata.name' 2>/dev/null)
    if [[ -z "$PODS" ]]; then
      echo "No ImagePullBackOff pods found"
      exit 0
    fi
    for POD in $PODS; do
      echo "Analyzing pod: $POD"
      kubectl describe pod "$POD" -n "$NAMESPACE" | grep -E "Image:|Error:"
    done
    echo "Action: Update image reference in local YAML and push"
    ;;
    
  notready)
    echo "--- NotReady Resources Fix ---"
    echo "Checking sources..."
    flux get sources -A | grep -v "True"
    echo ""
    echo "Checking kustomizations..."
    flux get kustomizations -A | grep -v "Reconciled"
    echo ""
    echo "Checking helm releases..."
    flux get helmreleases -A | grep -v "True"
    echo ""
    echo "Action: Run 'flux reconcile' on failed resources"
    ;;
    
  dependency)
    echo "--- DependencyNotReady Fix ---"
    KUSTS=$(flux get kustomizations -A 2>/dev/null | grep "DependencyNotReady" | awk '{print $3}')
    for KUST in $KUSTS; do
      echo "Fixing dependency for: $KUST"
      flux tree kustomization "$KUST" -n "$NAMESPACE" 2>/dev/null || true
      echo "Running reconcile with dependencies..."
      flux reconcile kustomization "$KUST" -n "$NAMESPACE" --with-source
    done
    ;;
    
  drift)
    echo "--- Drift Sync ---"
    if [[ -d "$COMPONENT_DIR" ]]; then
      echo "Checking for drift in $COMPONENT_DIR..."
      flux diff kustomization "$COMPONENT" -n "$NAMESPACE" --no-coalesce 2>/dev/null || true
      echo ""
      echo "Syncing from cluster to local..."
      # Export current state
      flux export kustomization "$COMPONENT" -n "$NAMESPACE" > "$COMPONENT_DIR/kustomization.yaml" 2>/dev/null || true
      echo "Synced to $COMPONENT_DIR/kustomization.yaml"
    else
      echo "Component directory not found: $COMPONENT_DIR"
      exit 1
    fi
    ;;
    
  *)
    echo "Unknown problem type: $PROBLEM"
    exit 1
    ;;
esac

echo ""
echo "=== Fix complete ==="