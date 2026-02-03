Important Advanced Commands

View everything (oldest first): journalctl
Follow live logs (real-time): journalctl -f
See logs for a specific service: journalctl -u nginx
See logs since a specific time: journalctl --since "1 hour ago"
See only errors: journalctl -p err -b (shows errors from the current boot)
Check how much disk space logs use: journalctl --disk-usage
