#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -un)" != "forensic01" ]]; then
  echo "Run this script as forensic01: su - forensic01"
  exit 1
fi

LOG_DIR="/home/forensic01/logs"
FILE="${LOG_DIR}/confidential.txt"

mkdir -p "${LOG_DIR}"
printf '%s\n' "Confidential sample content for the Linux Task 03 permissions exercise." > "${FILE}"

chmod 600 "${FILE}"
echo "Before ownership change:"
ls -l "${FILE}"

echo
echo "Changing owner to root (sudo may request forensic01's password)..."
sudo chown root:root "${FILE}"

echo
echo "After ownership change:"
ls -l "${FILE}"

echo
echo "Attempting to read as forensic01. Permission denied is expected:"
if cat "${FILE}"; then
  echo "NOTE: The read succeeded; inspect the file owner, mode, ACLs, and directory permissions."
else
  echo "Expected access failure observed for forensic01."
fi

echo
echo "Administrator verification command:"
echo "sudo ls -l '${FILE}'"
echo "sudo cat '${FILE}'"
