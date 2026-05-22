#!/usr/bin/env bash
# Deep-dive pod diagnostics
NS="${1:-default}"; POD="${2:?Usage: $0 namespace pod}"
echo "=== Pod Diagnostics: $NS/$POD ==="
echo ""
echo "--- Pod Description ---"
kubectl describe pod "$POD" -n "$NS" 2>/dev/null
echo ""
echo "--- Logs (last 100 lines) ---"
kubectl logs "$POD" -n "$NS" --tail=100 2>/dev/null || kubectl logs "$POD" -n "$NS" --previous --tail=50 2>/dev/null || true
echo ""
echo "--- Resource Usage ---"
kubectl top pod "$POD" -n "$NS" 2>/dev/null || echo "(metrics-server not available)"
