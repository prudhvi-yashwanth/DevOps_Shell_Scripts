# 📌 Linux Bash Scripting – 12 Practical Scenarios for DevOps Engineers

This repository contains **12 real-world Linux Bash scripting scenarios** commonly used by **DevOps Engineers** in daily operations and CI/CD pipelines.

These scenarios cover **90–95% of practical Bash scripting use cases** expected in DevOps roles and technical interviews.

---

## 1. Service Health Check & Auto-Restart

**Objective**
- Check if a service is running
- Restart the service if it is down
- Log service status and actions

**Concepts Covered**
- systemctl
- if-else
- exit codes
- logging

---

## 2. Disk Usage Monitoring

**Objective**
- Monitor disk usage
- Alert when usage exceeds a defined threshold

**Concepts Covered**
- df
- awk
- numeric comparison
- variables

---

## 3. Log Monitoring & Error Extraction

**Objective**
- Scan system or application logs
- Identify ERROR and FATAL entries
- Store extracted logs for review

**Concepts Covered**
- grep
- loops
- input/output redirection

---

## 4. Backup & Archive Automation

**Objective**
- Take backups of files or directories
- Compress backup files
- Add timestamps to backup names

**Concepts Covered**
- tar
- date
- variables

---

## 5. Cleanup Old Files (Log Rotation – Lite)

**Objective**
- Delete files older than a specified number of days

**Concepts Covered**
- find
- mtime
- exec

---

## 6. Script Arguments & Environment-Based Logic

**Objective**
- Change script behavior based on environment (dev/test/prod)

**Concepts Covered**
- positional parameters ($1, $2)
- conditional logic

---

## 7. Looping Over Servers or Files

**Objective**
- Execute commands on multiple servers or files

**Concepts Covered**
- for loop
- while loop

---

## 8. Exit Codes & Error Handling

**Objective**
- Detect command failures
- Stop script or pipeline execution on errors

**Concepts Covered**
- $?
- exit
- basic error handling

---

## 9. Environment Variables

**Objective**
- Use environment variables for configuration and secrets
- Avoid hardcoding sensitive values

**Concepts Covered**
- export
- environment variable access

---

## 10. Functions for Reusability

**Objective**
- Write modular and reusable Bash scripts

**Concepts Covered**
- bash functions
- clean scripting practices

---

## 11. CI/CD Helper Scripts

**Objective**
- Support CI/CD pipelines with automation scripts

**Examples**
- Build scripts
- Test scripts
- Deployment scripts

---

## 12. Docker & Kubernetes Support Scripts

**Objective**
- Automate common container and Kubernetes tasks

**Examples**
- Docker image cleanup
- Container health checks
- Kubernetes pod and service validation

---

## 🎯 Who Should Use This Repository?

- Aspiring DevOps Engineers
- Linux System Administrators
- CI/CD Engineers
- DevOps Interview Candidates

---

## 🚀 Outcome

After completing these scenarios, you will be able to:
- Read and understand production-level Bash scripts
- Write reliable Linux automation scripts
- Handle scripting questions confidently in interviews
- Apply scripting skills in real DevOps environments
