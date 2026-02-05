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

1. For Individual Users
If you have a specific user (e.g., alice) who needs full admin rights:
Syntax: username ALL=(ALL:ALL) ALL
Use Case: Personal admin accounts for human users.
Example: alice ALL=(ALL:ALL) ALL
2. For Groups (The Scalable Way)
If you want to give permissions to an entire team at once:
Syntax: %groupname ALL=(ALL:ALL) ALL
Use Case: Managing a team of 10+ engineers; you just add them to the Linux group.
Example: %devops ALL=(ALL:ALL) ALL (The % tells Linux this is a group).
3. For Automation (CI/CD Pipelines)
Tools like Jenkins, GitLab Runner, or GitHub Actions need to run commands without a human there to type a password.
Syntax: username ALL=(ALL:ALL) NOPASSWD: ALL
Use Case: Automated deployments where a password prompt would "hang" the process.
Example: jenkins ALL=(ALL:ALL) NOPASSWD: ALL
4. Restricted Permissions (The "Least Privilege" Principle)
This is the most secure method for production. Instead of giving "ALL" permissions, you specify only the commands the user needs.
Syntax: username ALL=(ALL:ALL) NOPASSWD: /path/to/cmd1, /path/to/cmd2
Example for a Monitoring Tool:
monitor ALL=(ALL:ALL) NOPASSWD: /usr/bin/systemctl restart nginx, /usr/bin/journalctl
Security Tip: Always use the full absolute path (e.g., /usr/bin/systemctl instead of just systemctl) to prevent attackers from running fake scripts with the same name.


This diagram is a breakdown of the Sudoers Grammar. Think of it as a four-part "Who, Where, As Whom, and What" security policy.
Here is the explanation of each component using the standard root entry as the example:
1. The Subject (Who)
root (or %admin, jenkins, etc.)
This is the starting point. It defines exactly which User or Group (if it has a % prefix) this rule belongs to.
2. The Host (Where)
ALL=(...
This defines which Machine the rule applies to.
In 99% of cases, you will see ALL. However, in large companies using a central network file, you might see a specific hostname. It means: "This user only has sudo powers when logged into the Production-Server."
3. The Run-As User & Group (As Whom)
=(ALL : ALL)
This is the "Acting Role." It defines whose identity the user can "steal."
The first ALL: The user can run commands as any User (like root, www-data, or db-admin).
The second ALL: The user can run commands as any Group.
Example: If this said (postgres), the user could only run commands as the postgres user.
4. The Command (What)
ALL
This is the most powerful part. It defines which programs the user can run.
ALL: The user can run every single command on the system (complete control).
Specific Path: If you change this to /usr/bin/systemctl, the user is "trapped" and can only run that one specific program.
Putting it together with your "Automation" needs:
If you wanted to write a rule for your CI/CD user to only restart Nginx, it would look like this:
User	Host	(User : Group)	Tag	Command
cicd_user	ALL	(root)	NOPASSWD:	/usr/bin/systemctl restart nginx
Summary Flow:
[User] can log into [Host] and act as [User/Group] to execute [Commands].


This is a classic DevOps scenario. To make this work smoothly and securely, you have to manage permissions at three different levels:
Your Permissions: To write and store the scripts.
The Scripts' Permissions: To be executable.
The Users' Permissions: To run the scripts and the "privileged" commands inside them.
Level 1: Your Permissions (Writing the Scripts)
As the DevOps Engineer, you need to store these scripts in a place where others can find them but only you (or other admins) can edit them.
The Directory: Store them in /usr/local/bin/ (the standard place for custom system-wide scripts).
Action: You need sudo just to move your scripts into this folder.
Ownership:
bash
sudo chown root:devops /usr/local/bin/myscript.sh
Use code with caution.

(This makes root the owner, but the devops group can see them.)
Level 2: The Scripts' Permissions (Execution)
A file in Linux is just a text file until you give it "Execute" permissions.
Command: sudo chmod 755 /usr/local/bin/myscript.sh
What this means:
7 (rwx): You (root) can read, write, and run it.
5 (r-x): The group and all other users can read and run it, but cannot change your code.
Level 3: The Users' Permissions (Running the Scripts)
This is where it gets interesting. Even if a user can run your script, the script will crash when it hits a command like systemctl restart because that user isn't root.
You have two choices here:
Choice A: The "Specific Command" Approach (Safest)
You don't give the 10 users permission to run the script as sudo; you give them permission to run the underlying commands inside the script without a password.
Identify commands: Suppose your scripts use systemctl and tail.
Create Sudoers file: /etc/sudoers.d/script-users
Add this line:
bash
%script_users ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/tail
Use code with caution.

Result: When the user runs your script, the script calls sudo systemctl, and it works silently.
Choice B: The "Wrapper" Approach (Easier for 10+ Scripts)
If your scripts do many complex things, you can allow the users to run the script itself as sudo.
Create Sudoers file: /etc/sudoers.d/script-exec
Add this line:
bash
%script_users ALL=(ALL) NOPASSWD: /usr/local/bin/script1.sh, /usr/local/bin/script2.sh
Use code with caution.

Result: The users run the script by typing: sudo /usr/local/bin/script1.sh. Because of the sudoers entry, it won't ask for a password, and the entire script runs with root power.
Summary Checklist for you as a DevOps Engineer:
Task	Command Example
1. Create a group for your 10 users	sudo groupadd script_users
2. Add users to that group	sudo usermod -aG script_users john_doe
3. Move scripts to a global path	sudo mv my_script.sh /usr/local/bin/
4. Make scripts executable	sudo chmod +x /usr/local/bin/my_script.sh
5. Grant Sudo access for the script	(Add the entry in /etc/sudoers.d/ as shown above)
Which one should you choose?
If your scripts are simple (only 1 or 2 commands), use Choice A. It is more secure.
If your scripts are complex (create files, move logs, restart services), use Choice B. It is much easier to manage.
