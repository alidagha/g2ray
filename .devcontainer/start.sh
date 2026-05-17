#!/bin/bash
# g2ray start script — Enterprise Edition

# ۱. پاکسازی سشن‌های قبلی
tmux kill-session -t g2ray 2>/dev/null || true

# ۲. اجرای هسته با قابلیت Auto-Restart (علامت > باعث می‌شود در هر بار ری‌استارت، فایل لاگ از صفر نوشته شود تا رم پر نشود)
tmux new-session -d -s g2ray "bash -c 'while true; do xray run -c /etc/xray/g2ray.json > /tmp/xray.log 2>&1; sleep 2; done'"

# ۳. اجرای Keepalive با Health-Check هوشمند (به جای sleep 10)
tmux new-window -t g2ray -n keepalive "bash -c '
  echo \"[Health Check] Waiting for Xray to bind port 443...\"
  while ! curl -s localhost:443 >/dev/null; do 
      sleep 1 
  done
  echo \"[Health Check] Port 443 is UP! Starting Keepalive loop...\"
  while true; do 
      curl -s --max-time 5 https://github.com/ -o /dev/null
      sleep 180
  done
'"

# ۴. تولید لینک‌ها
/usr/local/bin/show-link.sh

echo "[g2ray] مانیتورینگ سلامت و Keepalive فعال شد"
echo "[g2ray] برای دیدن log: tmux attach -t g2ray"
