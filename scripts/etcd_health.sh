#!/usr/bin/env bash
# etcd cluster health check
ETCD_ENDPOINTS="${ETCD_ENDPOINTS:-https://127.0.0.1:2379}"
ETCD_CACERT="${ETCD_CACERT:-/etc/kubernetes/pki/etcd/ca.crt}"
ETCD_CERT="${ETCD_CERT:-/etc/kubernetes/pki/etcd/healthcheck-client.crt}"
ETCD_KEY="${ETCD_KEY:-/etc/kubernetes/pki/etcd/healthcheck-client.key}"

ETCD_ARGS="--endpoints=$ETCD_ENDPOINTS --cacert=$ETCD_CACERT --cert=$ETCD_CERT --key=$ETCD_KEY"

echo "=== etcd Health ==="
etcdctl $ETCD_ARGS endpoint health 2>/dev/null
echo ""
echo "--- Member List ---"
etcdctl $ETCD_ARGS member list -w table 2>/dev/null
echo ""
echo "--- Endpoint Status ---"
etcdctl $ETCD_ARGS endpoint status -w table 2>/dev/null
echo ""
echo "--- DB Size ---"
etcdctl $ETCD_ARGS endpoint status 2>/dev/null |     python3 -c "import sys,json; [print(f'  {m[\"Endpoint\"]}: {m[\"Status\"][\"dbSize\"]//1024//1024}MB') for m in json.load(sys.stdin) if isinstance(m,dict)]" 2>/dev/null || true
