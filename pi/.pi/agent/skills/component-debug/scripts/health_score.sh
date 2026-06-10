#!/bin/bash
# Health Score Calculator
# Usage: ./health_score.sh <namespace>
# Returns: Health score (0-100)

NAMESPACE="${1:-}"
if [[ -z "$NAMESPACE" ]]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

SCORE=0

# 1. Pods (30%)
echo -n "Pods: "
POD_TOTAL=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l || echo 0)
POD_RUNNING=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | grep -c "Running" || echo 0)
CRASHLOOP=$(kubectl get pods -n "$NAMESPACE" -o json 2>/dev/null | jq -r '.items[] | select(.status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff") | .metadata.name' 2>/dev/null | wc -l || echo 0)

if [[ "$POD_TOTAL" -gt 0 ]]; then
  POD_SCORE=$((POD_RUNNING * 100 / POD_TOTAL))
  POD_SCORE=$((POD_SCORE - CRASHLOOP * 10))
  [[ $POD_SCORE -lt 0 ]] && POD_SCORE=0
  SCORE=$((SCORE + POD_SCORE * 30 / 100))
  echo "$POD_RUNNING/$POD_TOTAL Running (CrashLoop: $CRASHLOOP) → $POD_SCORE%"
else
  echo "0 pods found → 0%"
fi

# 2. Flux Sources (25%)
echo -n "Flux Sources: "
SOURCE_TOTAL=$(flux get sources -A 2>/dev/null | grep "$NAMESPACE" | wc -l || echo 0)
SOURCE_READY=$(flux get sources -A 2>/dev/null | grep "$NAMESPACE" | grep -c "True" || echo 0)
if [[ "$SOURCE_TOTAL" -gt 0 ]]; then
  SOURCE_SCORE=$((SOURCE_READY * 100 / SOURCE_TOTAL))
  SCORE=$((SCORE + SOURCE_SCORE * 25 / 100))
  echo "$SOURCE_READY/$SOURCE_TOTAL Ready → $SOURCE_SCORE%"
else
  echo "0 sources → 0%"
fi

# 3. Flux Kustomizations (25%)
echo -n "Kustomizations: "
KUST_TOTAL=$(flux get kustomizations -A 2>/dev/null | grep "$NAMESPACE" | wc -l || echo 0)
KUST_RECONCILED=$(flux get kustomizations -A 2>/dev/null | grep "$NAMESPACE" | grep -c "Reconciled" || echo 0)
if [[ "$KUST_TOTAL" -gt 0 ]]; then
  KUST_SCORE=$((KUST_RECONCILED * 100 / KUST_TOTAL))
  SCORE=$((SCORE + KUST_SCORE * 25 / 100))
  echo "$KUST_RECONCILED/$KUST_TOTAL Reconciled → $KUST_SCORE%"
else
  echo "0 kustomizations → 0%"
fi

# 4. Events (20%)
echo -n "Events: "
ERROR_COUNT=$(kubectl get events -n "$NAMESPACE" --sort-by='.lastTimestamp' 2>/dev/null | grep -cE "Error|Failed|Warning" || echo 0)
if [[ "$ERROR_COUNT" -eq 0 ]]; then
  EVENT_SCORE=100
else
  EVENT_SCORE=0
fi
SCORE=$((SCORE + EVENT_SCORE * 20 / 100))
echo "$ERROR_COUNT errors/warnings → $EVENT_SCORE%"

echo ""
echo "=== TOTAL HEALTH SCORE: $SCORE% ==="

# Exit code based on score
if [[ "$SCORE" -ge 80 ]]; then
  exit 0  # Good
elif [[ "$SCORE" -ge 50 ]]; then
  exit 1  # Warning
else
  exit 2  # Critical
fi