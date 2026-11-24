#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo: sudo bash $0"
  exit 1
fi

for username in guest1 guest2; do
  if id "${username}" >/dev/null 2>&1; then
    echo "User ${username} already exists; leaving it in place."
  else
    useradd --create-home --shell /bin/bash "${username}"
    echo "Created ${username}."
  fi
done

usermod --append --groups sudo guest1
echo "Added guest1 to the sudo group."

echo
echo "Verification before deleting guest2:"
id guest1
id guest2

echo
read -r -p "This will permanently delete guest2 and its home directory. Continue? [y/N] " answer
case "${answer}" in
  y|Y|yes|YES)
    userdel --remove guest2
    echo "Deleted guest2 and its home directory."
    ;;
  *)
    echo "Deletion cancelled. Run this script again when ready."
    exit 0
    ;;
esac

echo
echo "Final verification:"
id guest1
if id guest2 >/dev/null 2>&1; then
  echo "guest2 still exists."
else
  echo "guest2 no longer exists."
fi
