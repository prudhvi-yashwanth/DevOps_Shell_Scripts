#!/bin/bash

#####################################################
# Author: Prudhvi Yashwanth Reddy Kikkuru
# Date: 11th October 2025
# Version: V2 - Enterprise Grade
# Description: Monitors AWS resources and logs usage
#####################################################

set -euo pipefail

# === Config ===
DATE=$(date +"%d%b%Y_%H:%M")
LOG_DIR="/var/log/aws-monitor"
LOG_FILE="$LOG_DIR/tracker_$DATE.log"

# === Ensure log directory exists ===
mkdir -p "$LOG_DIR"

# === Check AWS CLI ===
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Install it before running this script." | tee -a "$LOG_FILE"
    exit 1
fi

# === Check IAM Role or Credentials ===
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials or IAM role not configured." | tee -a "$LOG_FILE"
    exit 1
fi

# === Start Logging ===
echo "===== AWS Resource Usage Report =====" | tee -a "$LOG_FILE"
echo "Generated on: $(date)" | tee -a "$LOG_FILE"
echo "=====================================" | tee -a "$LOG_FILE"

# === S3 Buckets ===
echo -e "\n[S3 Buckets]" | tee -a "$LOG_FILE"
aws s3 ls | tee -a "$LOG_FILE"

# === EC2 Instances ===
echo -e "\n[EC2 Instances]" | tee -a "$LOG_FILE"
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress,LaunchTime]" \
  --output table | tee -a "$LOG_FILE"

# === Lambda Functions ===
echo -e "\n[Lambda Functions]" | tee -a "$LOG_FILE"
aws lambda list-functions \
  --query "Functions[*].[FunctionName,Runtime,LastModified]" \
  --output table | tee -a "$LOG_FILE"

# === IAM Users ===
echo -e "\n[IAM Users]" | tee -a "$LOG_FILE"
aws iam list-users \
  --query "Users[*].[UserName,CreateDate]" \
  --output table | tee -a "$LOG_FILE"

# === Completion ===
echo -e "\n✅ Report saved to $LOG_FILE"