#!/usr/bin/env bash
echo "=== K8s Resource Usage ==="
echo ""
echo "--- Node Resources ---"
kubectl top nodes 2>/dev/null || echo "(metrics-server required)"
echo ""
echo "--- Pod Resource Requests vs Limits ---"
kubectl get pods --all-namespaces -o json 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'  {\"NS\":<25} {\"Pod\":<45} {\"CPU Req\":<12} {\"Mem Req\"}')
print('  '+'-'*95)
for pod in data.get('items',[]):
    ns   = pod['metadata']['namespace']
    name = pod['metadata']['name']
    for c in pod['spec'].get('containers',[]):
        req = c.get('resources',{}).get('requests',{})
        cpu = req.get('cpu','none')
        mem = req.get('memory','none')
        print(f'  {ns:<25} {name:<45} {cpu:<12} {mem}')
" | head -50
echo ""
echo "--- Namespace Resource Quotas ---"
kubectl get resourcequota --all-namespaces 2>/dev/null | head -20
