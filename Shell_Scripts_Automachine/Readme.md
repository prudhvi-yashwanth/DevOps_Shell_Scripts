# AWS Resource Monitoring Script

## 🧭 Overview

This Bash script monitors key AWS resources—including S3 buckets, EC2 instances, Lambda functions, and IAM users—and generates a comprehensive usage report. Logs are saved in timestamped files under `/var/log/aws-monitor`, providing DevOps engineers and AWS administrators with valuable insights for audits and operational visibility.

---

## ✨ Features

- Verifies AWS CLI installation and configuration
- Lists all S3 buckets in the account
- Displays EC2 instance details: status, type, IP address, and launch time
- Retrieves metadata for AWS Lambda functions
- Enumerates IAM users with their creation dates
- Saves output to a uniquely timestamped log file for traceability

---

## ⚙️ Requirements

- **OS:** Linux/Unix environment with Bash
- **AWS CLI:** Installed and configured (`aws configure`)
- **IAM Permissions:** Access to list S3, EC2, Lambda, and IAM resources
- **Root Access:** Required to write logs to `/var/log`  
  *(Alternatively, update the `LOG_DIR` variable in the script to a writable path)*

---

## 🚀 Installation

1. Clone or download the script to your server.
2. Make the script executable:
   ```bash
   chmod +x aws-resource-monitor.sh
   ```
3. Configure AWS CLI credentials:
   ```bash
   aws configure
   ```

---

## 📌 Usage

> **Note:** Run the script with `sudo` to ensure write access to `/var/log/aws-monitor`.

Upon execution, the script generates a log file in `/var/log/aws-monitor/` with a filename like:

```
aws-monitor-YYYY-MM-DD_HH-MM-SS.log
```

---

## 🛠️ Customization

- To change the log directory, modify the `LOG_DIR` variable in the script.
- You can add or remove AWS resource sections based on your monitoring needs.

---

## 🧯 Troubleshooting

- **Permission Denied:**  
  Ensure you have sudo privileges or set `LOG_DIR` to a writable location.
- **AWS CLI Not Found:**  
  Install it using your package manager (e.g., `sudo apt install awscli`)
- **Authentication Issues:**  
  Reconfigure credentials using `aws configure` or assign appropriate IAM roles.

---

## 📄 License

MIT License  
© 2025 Prudhvi Yashwanth Reddy Kikkuru

---

## 👤 Author

**Prudhvi Yashwanth Reddy Kikkuru**  
DevOps Engineer, TCS  
Currently exploring advanced DevOps practices and Python automation

---
