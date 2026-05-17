#!/bin/bash
# g2ray start script — keepalive: 180s

# ۱. پاکسازی سشن‌های قبلی
tmux kill-session -t g2ray 2>/dev/null || true

# ۲. اجرای هسته Xray با سینتکس استاندارد bash برای جلوگیری از باگ‌های لاگ‌گیری
tmux new-session -d -s g2ray "bash -c 'xray run -c /etc/xray/g2ray.json > /tmp/xray.log 2>&1'"

# ۳. اجرای حلقه Keepalive با ۱۰ ثانیه تأخیر
tmux new-window -t g2ray -n keepalive "bash -c 'sleep 10; while true; do curl -s --max-time 5 https://github.com/ -o /dev/null; sleep 180; done'"

# ۴. نمایش لینک
/usr/local/bin/show-link.sh

echo "[g2ray] Keepalive فعال است — هر 180 ثانیه یک بار ping"
echo "[g2ray] سرور داخل tmux اجرا شد"
echo "[g2ray] برای دیدن log: tmux attach -t g2ray"
