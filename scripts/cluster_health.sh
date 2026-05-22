#!/usr/bin/env bash
set -uo pipefail
echo "=== Kubernetes Cluster Health — $(date) ==="
echo "Context: $(kubectl config current-context 2>/dev/null)"
echo ""
echo "--- Nodes ---"
kubectl get nodes -o wide 2>/dev/null | head -20
echo ""
echo "--- Not-Running Pods (all namespaces) ---"
kubectl get pods --all-namespaces --field-selector='status.phase!=Running' 2>/dev/null |     grep -v "^NAMESPACE\|Completed" | head -30
echo ""
echo "--- Recent Events (Warnings) ---"
kubectl get events --all-namespaces --sort-by='.lastTimestamp' 2>/dev/null |     grep Warning | tail -20
echo ""
echo "--- PVCs not Bound ---"
kubectl get pvc --all-namespaces 2>/dev/null | grep -v Bound | head -15
echo ""
echo "--- Component Status ---"
kubectl get componentstatuses 2>/dev/null || kubectl get cs 2>/dev/null || echo "(component status deprecated in newer K8s)"
