#!/usr/bin/env bash
set -euo pipefail

USER_NAME="forensic01"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo: sudo bash $0"
  exit 1
fi

if ! getent group sudo >/dev/null; then
  echo "The sudo group was not found. This script targets Kali/Debian systems."
  exit 1
fi

if id "${USER_NAME}" >/dev/null 2>&1; then
  echo "User ${USER_NAME} already exists; leaving the account unchanged."
else
  useradd --create-home --shell /bin/bash "${USER_NAME}"
  echo "Created ${USER_NAME} with a home directory and /bin/bash."
fi

usermod --append --groups sudo "${USER_NAME}"
echo "Added ${USER_NAME} to the sudo group."
echo "Set the password interactively. Password characters will not be displayed."
passwd "${USER_NAME}"

echo
echo "Verification:"
id "${USER_NAME}"
getent passwd "${USER_NAME}"
