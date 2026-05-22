#!/usr/bin/env bash
# Check Kubernetes API server certificate expiry
echo "=== K8s Certificate Expiry Check ==="
CERT_DIR="/etc/kubernetes/pki"
[ ! -d "$CERT_DIR" ] && echo "Cert dir not found (not a control plane node?)" && exit 0
WARN_DAYS="${WARN_DAYS:-30}"
for cert in "$CERT_DIR"/*.crt; do
    [ -f "$cert" ] || continue
    EXPIRY=$(openssl x509 -noout -enddate -in "$cert" 2>/dev/null | cut -d= -f2)
    [ -z "$EXPIRY" ] && continue
    DAYS=$( (( $(date -d "$EXPIRY" +%s) - $(date +%s) )) / 86400 || echo 0)
    ICON="✅"; [ "$DAYS" -lt "$WARN_DAYS" ] && ICON="⚠️ "
    printf "%s  %-45s %s (%d days)\n" "$ICON" "$(basename $cert)" "$EXPIRY" "$DAYS"
done
if command -v kubeadm &>/dev/null; then
    echo ""
    echo "--- kubeadm certs check ---"
    kubeadm certs check-expiration 2>/dev/null | head -20
fi
