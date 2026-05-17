#!/bin/bash
# g2ray start script — keepalive: 180s

# ۱. پاکسازی سشن‌های قبلی (جلوگیری از تداخل)
tmux kill-session -t g2ray 2>/dev/null || true

# ۲. اجرای هسته Xray همراه با حلقه ری‌استارت خودکار (مقاوم در برابر کرش)
tmux new-session -d -s g2ray "bash -c 'while true; do xray run -c /etc/xray/g2ray.json >> /tmp/xray.log 2>&1; sleep 2; done'"

# ۳. اجرای حلقه Keepalive در یک پنجره جدید (با ۱۰ ثانیه تأخیر اولیه)
tmux new-window -t g2ray -n keepalive "bash -c 'sleep 10; while true; do curl -s --max-time 5 https://github.com/ -o /dev/null; sleep 180; done'"

# ۴. تولید و نمایش لینک (در صورت نیاز به بررسی دستی)
/usr/local/bin/show-link.sh

echo "[g2ray] Keepalive فعال است — هر 180 ثانیه یک بار ping"
echo "[g2ray] سرور داخل tmux اجرا شد و مجهز به Auto-Restart است"
echo "[g2ray] برای دیدن log: tmux attach -t g2ray"
