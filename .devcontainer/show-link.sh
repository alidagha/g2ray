#!/bin/bash
CONFIG="/etc/xray/g2ray.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ -z "$UUID" ]; then echo "[g2ray] UUID پیدا نشد."; exit 1; fi
SNI="${CODESPACE_NAME}-443.app.github.dev"
IPS=("94.130.50.12" "50.7.5.83" "63.141.252.203")

# بررسی وضعیت واقعی سرور (تله‌شکن و صحت‌سنجی واقعی)
if [ ! -f /tmp/server_ready ]; then
    echo -n "⏳ [g2ray] در حال راه‌اندازی هسته و تست پایداری شبکه... لطفاً شکیبا باشید"
    TIMEOUT=40
    while [ ! -f /tmp/server_ready ] && [ $TIMEOUT -gt 0 ]; do
        sleep 1
        ((TIMEOUT--))
        echo -n "."
    fi
    echo ""
    
    if [ $TIMEOUT -le 0 ]; then
        echo "❌ [خطا] زمان انتظار به پایان رسید! سرور یا پورت ۴۴۳ به طور کامل فعال نشد."
        echo "🔍 برای بررسی علت خطا دستور مقابل را بزنید: tmux attach -t g2ray"
        exit 1
    fi
fi

# چاپ لینک‌ها پس از اطمینان از زنده بودن و روان بودن مطلق سرور
echo ""
echo "====================================================="
echo "   ✅ سرور کاملاً فعال، روان و آماده اتصال است!      "
echo "====================================================="

for IP in "${IPS[@]}"; do
    LINK="vless://${UUID}@${IP}:443?encryption=none&security=tls&sni=${SNI}&host=${SNI}&fp=chrome&allowInsecure=1&type=xhttp&mode=packet-up&path=%2F#swift-hub-a167cc-[${IP}]"
    echo " 🌐 IP: $IP"
    echo " $LINK"
    echo "-----------------------------------------------------"
done
echo ""
