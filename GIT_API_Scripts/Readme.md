# GitHub API Access Tracker

A Bash script to audit and log users with **read (pull) access** on any GitHub repository.  
Useful for **auditing, compliance, and security monitoring**.

---

## ✨ Features

- Lists all users with **read access** to a given GitHub repository
- Logs results with **timestamps** to `/var/log/git-api-monitor`
- Validates required parameters and dependencies before execution
- Uses **secure authentication** via environment variables for GitHub Personal Access Tokens (PATs)
- Provides **clear error messages** and usage instructions

---

## 📋 Requirements

- **Operating System:** Linux/Unix with Bash
- **Dependencies:**
  - [jq](https://stedolan.github.io/jq/) → JSON parsing
  - [curl](https://curl.se/) → HTTP requests
- **GitHub Personal Access Token (PAT):**
  - Requires at least `repo` and `read:org` scopes (depending on repository visibility)
- **Permissions:**
  - Root/sudo access if writing logs to `/var/log`
  - (Optional) Change the log directory if you don’t want to use `/var/log`

---

## ⚙️ Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```

2. Make the script executable:
   ```bash
   chmod +x git-api-monitor.sh
   ```

3. Install dependencies (if missing):
   ```bash
   sudo apt update
   sudo apt install jq curl
   ```

---

## 🔑 Setup

### 1. Generate a GitHub Personal Access Token
- Create a PAT with the required scopes: [GitHub PAT Settings](https://github.com/settings/tokens)

### 2. Export your credentials as environment variables
```bash
export GIT_USERNAME="your_github_user"
export GIT_TOKEN="your_github_token"
```

> 💡 **Tip:** Using environment variables avoids exposing secrets in shell history.

---

## 🚀 Usage

Run the script with the repository owner and repository name:

```bash
sudo ./git-api-monitor.sh <RepoOwner> <RepoName>
```

**Example:**
```bash
sudo ./git-api-monitor.sh octocat hello-world
```

Logs will be saved to:
```
/var/log/git-api-monitor/git_api_tracker_<DATE>.log
```

---

## 📄 Example Output

```
=== Users with read access to 'octocat/hello-world' ===
Users with read access to the repository 'hello-world':
octocat
other-user
```

---

## 🔧 Customization

- **Change log directory:**  
  Edit the `LOG_DIR` variable in the script:
  ```bash
  LOG_DIR="/your/custom/path"
  ```

- **Log more details:**  
  Modify the `jq` filter to include additional fields from the GitHub API response.

---

## 🛠️ Troubleshooting

- **Error: jq is not installed.**  
  → Install with `sudo apt install jq`

- **Error: Missing required parameters.**  
  → Ensure you provide both `<RepoOwner>` and `<RepoName>`  
  → Ensure `GIT_USERNAME` and `GIT_TOKEN` are exported

- **Permission denied writing log file.**  
  → Run with `sudo` or change `LOG_DIR` to a writable location

---

## 🔒 Security Notes

- Never hard-code your GitHub token in the script or repository
- Rotate PAT tokens regularly
- Use the **minimum required scopes** for your token

---

## 📜 License

MIT License  
© 2025 **Prudhvi Yashwanth Reddy Kikkuru**

---

## 👤 Author

**Prudhvi Yashwanth Reddy Kikkuru**  
DevOps Engineer, TCS  
Currently exploring advanced DevOps practices and Python automation

---