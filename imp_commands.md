Important Advanced Commands

systemctl is for managing services (starting/stopping), journalctl is for reading the logs those services produce
View everything (oldest first): journalctl
Follow live logs (real-time): journalctl -f
See logs for a specific service: journalctl -u nginx
See logs since a specific time: journalctl --since "1 hour ago"
See only errors: journalctl -p err -b (shows errors from the current boot)
Check how much disk space logs use: journalctl --disk-usage


Common Commands
Fetch a webpage's HTML: curl https://example.com
Download and save a file: curl -o filename.jpg https://example.com/image.jpg
Send POST data to an API: curl -d "name=John" https://api.example.com/user
Follow redirects (301/302): curl -L https://short.url
Use authentication: curl -u username:password https://secure-site.com    
