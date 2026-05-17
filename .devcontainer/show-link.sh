#!/bin/bash
CONFIG="/etc/xray/g2ray.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ -z "$UUID" ]; then echo "[g2ray] UUID پیدا نشد."; exit 1; fi
SNI="${CODESPACE_NAME}-443.app.github.dev"

# تعریف آرایه‌ای از آی‌پی‌های تمیز
IPS=("94.130.50.12" "50.7.5.83" "63.141.252.203")

echo ""
echo "====================================================="
echo "             لینک‌های اتصال (Multi-IP)               "
echo "====================================================="

# حلقه برای ساخت و چاپ لینک به ازای هر آی‌پی
for IP in "${IPS[@]}"; do
    LINK="vless://${UUID}@${IP}:443?encryption=none&security=tls&sni=${SNI}&host=${SNI}&fp=chrome&allowInsecure=1&type=xhttp&mode=packet-up&path=%2F#swift-hub-a167cc-[${IP}]"
    echo " 🌐 IP: $IP"
    echo " $LINK"
    echo "-----------------------------------------------------"
done
echo ""
