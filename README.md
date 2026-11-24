# Linux Task 03 — GitHub Workflow

A guided, Kali/Debian-compatible workflow for completing **Linux Task 03** (New User Setup, Log Filtering & Analysis, Permissions/Ownership, and User Management).

> **Safety:** Run this only in your own Kali Linux virtual machine or another system you are authorized to administer. The scripts create/delete local accounts. `04_user_management.sh` deletes `guest2` and its home directory. Review every script before running it. Do not use real or reused passwords.

## Repository layout

```text
linux-task-03-github-workflow/
├── README.md
├── .gitignore
├── commands_used.txt
├── scripts/
│   ├── 01_create_forensic_user.sh
│   ├── 02_log_analysis.sh
│   ├── 03_permissions_ownership.sh
│   └── 04_user_management.sh
├── screenshots/
│   └── README.md
├── evidence/
│   └── README.md
└── reports/
    └── README.md
```

## Requirements

- Kali Linux / Debian-based Linux
- A terminal account with `sudo` privileges
- Bash and standard utilities (`useradd`, `usermod`, `passwd`, `grep`, `less`, `head`, `tail`, `chmod`, `chown`, `userdel`)
- A local VM snapshot or backup is recommended before account-management exercises

## Quick start

Clone your repository, then enter it:

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
cd linux-task-03-github-workflow
chmod +x scripts/*.sh
```

### Part 1 — Create `forensic01` (run as your administrator account)

```bash
sudo bash scripts/01_create_forensic_user.sh
```

The script creates `forensic01` with a home directory and `/bin/bash`, adds the account to the `sudo` group, and invokes `passwd` so you can set its password interactively. **Type the password at the prompt; it will not be stored in this repository.**

Log in as the new user:

```bash
su - forensic01
```

### Part 1 continued / Part 2 — Create and analyze logs (run as `forensic01`)

From the repository directory (or use its full path), run:

```bash
bash scripts/02_log_analysis.sh
```

The script creates `/home/forensic01/logs/sys_events.log` with 20+ timestamped mock entries using `cat` and `echo`. It displays ERROR matches, filters lines mentioning `root` or `user01`, shows the first and last five lines, displays the full log, and writes `error_report.txt` to the logs directory. It also pipes the ERROR results through `tee` and `less` so the report is saved while the output can be viewed interactively. Press `q` to exit `less`.

Useful individual commands (run from the logs directory):

```bash
cd /home/forensic01/logs
grep "ERROR" sys_events.log
grep -E "root|user01" sys_events.log
grep "ERROR" sys_events.log | tee error_report.txt | less
head -n 5 sys_events.log
tail -n 5 sys_events.log
cat sys_events.log
```

### Part 3 — Permissions and ownership (run as `forensic01`)

```bash
bash scripts/03_permissions_ownership.sh
```

The script creates `confidential.txt`, applies mode `600` (owner read/write; group and others no access), then uses `sudo chown root:root` to transfer ownership to root. It attempts to read the file as `forensic01`; a **Permission denied** result is expected because the file is owned by root and has mode `600`.

To capture the test explicitly, run:

```bash
cat /home/forensic01/logs/confidential.txt
```

That command should fail when run as `forensic01`. To verify the file as an administrator:

```bash
sudo ls -l /home/forensic01/logs/confidential.txt
sudo cat /home/forensic01/logs/confidential.txt
```

Expected permissions are `-rw-------` and owner `root`. Do not change permissions just to hide the expected result; record what happened.

### Part 4 — Temporary user management (run as your administrator account)

Exit the `forensic01` shell first:

```bash
exit
sudo bash scripts/04_user_management.sh
```

This creates `guest1` and `guest2`, adds `guest1` to the `sudo` group, and removes `guest2` including its home directory. The script asks for confirmation before deletion.

## Submission evidence

1. Save actual terminal screenshots in `screenshots/` (see `screenshots/README.md`).
2. Save command output or text evidence in `evidence/` and generated `error_report.txt` in `reports/` if you copy it there.
3. Record the exact commands you personally ran in `commands_used.txt`.
4. Complete the short explanations at the end of `commands_used.txt` or in your report.

Suggested evidence:
- `01-user-created.png`: `id forensic01`, `getent passwd forensic01`, and `groups forensic01`
- `02-log-analysis.png`: ERROR grep, `root|user01` grep, head/tail output
- `03-error-report.png`: `error_report.txt` and `less` output
- `04-permissions.png`: `ls -l confidential.txt` showing root ownership and `-rw-------`
- `05-access-denied.png`: failed read as `forensic01`
- `06-user-management.png`: `id guest1`, `getent passwd guest2` showing no result after deletion, and `groups guest1`

**Do not submit fabricated screenshots.** Capture your own terminal output after running the commands.

## GitHub upload

```bash
git init
git add .
git commit -m "Add Linux Task 03 workflow and evidence structure"
git branch -M main
git remote add origin <YOUR-GITHUB-REPOSITORY-URL>
git push -u origin main
```

Replace the placeholder URL with your own repository URL. Never commit passwords, private keys, or unrelated personal data.
