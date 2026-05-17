#!/bin/bash
# g2ray start script — Real Verification Edition

# ۱. پاکسازی سشن‌های قبلی و سیگنال قدیمی
tmux kill-session -t g2ray 2>/dev/null || true
rm -f /tmp/server_ready

# ۲. اجرای هسته Xray در پس‌زمینه (Auto-Restart)
tmux new-session -d -s g2ray "bash -c 'while true; do xray run -c /etc/xray/g2ray.json > /tmp/xray.log 2>&1; sleep 2; done'"

# ۳. حلقه کنترل کیفیت: پابلیک کردن پورت + تست پایداری + ارسال سیگنال READY
tmux new-window -t g2ray -n monitor "bash -c '
  # الف) صبر تا زمانی که Xray پورت 443 را با موفقیت باز کند
  while ! timeout 1 bash -c \"cat < /dev/null > /dev/tcp/127.0.0.1/443\" 2>/dev/null; do 
      sleep 1 
  done
  
  # ب) تلاش مداوم برای پابلیک کردن پورت در شبکه گیت‌هاب
  until gh codespace ports visibility 443:public -c \$CODESPACE_NAME 2>/dev/null; do 
      sleep 2 
  done
  
  # ج) ایجاد فایل سیگنال آمادگی واقعی (حالا همه‌چیز روان و وصل است)
  echo \"READY\" > /tmp/server_ready
  
  # د) شروع حلقه کیپ‌الایو برای زنده نگه داشتن کانتینر
  while true; do 
      curl -s --max-time 5 https://github.com/ -o /dev/null
      sleep 180
  done
'"
