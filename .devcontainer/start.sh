#!/bin/bash
# g2ray start script — Auto-Show Links Edition

# ۱. پاکسازی سشن‌های قبلی (جلوگیری از تداخل)
tmux kill-session -t g2ray 2>/dev/null || true

# ۲. اجرای هسته با قابلیت Auto-Restart (بازنویسی لاگ در هر استارت برای محافظت از رم)
tmux new-session -d -s g2ray "bash -c 'while true; do xray run -c /etc/xray/g2ray.json > /tmp/xray.log 2>&1; sleep 2; done'"

# ۳. اجرای Keepalive با Health-Check هوشمند و مجهز به تله‌شکن (Timeout 30s)
tmux new-window -t g2ray -n keepalive "bash -c '
  echo \"[Health Check] Waiting up to 30s for Xray to bind port 443...\"
  TIMEOUT=30
  while ! curl -s localhost:443 >/dev/null; do 
      sleep 1
      ((TIMEOUT--))
      if [ \"\$TIMEOUT\" -le 0 ]; then
          echo \"[Warning] Xray timeout reached! Breaking loop...\"
          break
      fi
  done
  
  # شگفتانه: به محض اینکه پورت باز شد و سرور فعال گشت، لینک‌ها رو همین‌جا چاپ کن!
  echo \"[Health Check] Server is UP and Active! Generating links...\"
  /usr/local/bin/show-link.sh
  
  while true; do 
      curl -s --max-time 5 https://github.com/ -o /dev/null
      sleep 180
  done
'"

echo "[g2ray] سرور با موفقیت استارت شد."
echo "[g2ray] لطفاً چند ثانیه صبر کنید... به محض فعال شدن کامل پروکسی، لینک‌ها خودبه‌خود نمایش داده می‌شوند."
