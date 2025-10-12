#!/bin/bash

##################################################
# Author: Prudhvi Yashwanth Reddy Kikkuru
# Date: 12th October 2025
# Description: Tracks GITHUB API Access and logs users
# Version: 1.0
##################################################

set -euo pipefail
#set -x # Uncomment for debugging

# === Pre-Checks ===

# Check for jq
if ! command -v jq > /dev/null; then
    echo "Error: 'jq' is not installed. Install it and rerun. (sudo apt install jq)"
    exit 1
fi

# === Read GitHub credentials from environment variables ===
: "${GIT_USERNAME:?Environment variable GIT_USERNAME not set}"
: "${GIT_TOKEN:?Environment variable GIT_TOKEN not set}"

git_userName="$GIT_USERNAME"
git_UserToken="$GIT_TOKEN"

# === User and Repository Details ===
git_RepoOwner="${1:-}"
git_RepoName="${2:-}"

# === GitHub API Base URL ===
gitHub_API_BaseURL="https://api.github.com"

# === Configuration File ===
DATE=$(date +"%d-%b-%Y_%H:%M:%S")
LOG_DIR="/var/log/git-api-monitor"
LOG_FILE="$LOG_DIR/git_api_tracker_$DATE.log"

# === Function to check required parameters ===
checkParameters() {
    if [ -z "$git_userName" ] || [ -z "$git_UserToken" ] || [ -z "$git_RepoOwner" ] || [ -z "$git_RepoName" ]; then
        echo "Error: Missing required parameters."
        echo "Usage: GIT_USERNAME=<username> GIT_TOKEN=<token> $0 <RepoOwner> <RepoName>"
        exit 1
    fi
}

# === Function to list users with read access ===
list_users_with_read_access() {
    local endpoint="repos/${git_RepoOwner}/${git_RepoName}/collaborators"
    local url="${gitHub_API_BaseURL}/${endpoint}"

    response=$(curl -s -u "${git_userName}:${git_UserToken}" \
        -H "Accept: application/vnd.github.v3+json" "$url" | \
        jq -r '.[] | select(.permissions.pull == true) | .login')

    if [ -z "$response" ]; then
        echo "No users with read access found or unable to fetch data."
        return 1
    else
        echo "Users with read access to the repository '$git_RepoName':"
        echo "$response"
    fi
}

# === Function to log users to file ===
log_users_to_file() {
    mkdir -p "$LOG_DIR"
    echo "=== Users with read access to '${git_RepoOwner}/${git_RepoName}' ===" >> "$LOG_FILE"
    list_users_with_read_access >> "$LOG_FILE" || echo "Failed to list users." >> "$LOG_FILE"
    echo "User access details logged to $LOG_FILE"
}

# === Main Execution ===
echo "Listing users with read access to ${git_RepoOwner}/${git_RepoName}..."
checkParameters
log_users_to_file

echo "Script execution completed."
exit 0
