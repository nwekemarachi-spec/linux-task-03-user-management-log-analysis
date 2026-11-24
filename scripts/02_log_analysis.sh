#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -un)" != "forensic01" ]]; then
  echo "Run this script after logging in as forensic01: su - forensic01"
  exit 1
fi

LOG_DIR="/home/forensic01/logs"
LOG_FILE="${LOG_DIR}/sys_events.log"
REPORT="${LOG_DIR}/error_report.txt"

mkdir -p "${LOG_DIR}"

# Create the sample log using a here-document with cat, then append with echo.
cat > "${LOG_FILE}" <<'LOGS'
2026-11-24 08:00:01 INFO system boot completed by root
2026-11-24 08:03:12 INFO user01 logged in successfully
2026-11-24 08:05:44 WARNING failed login attempt for user01
2026-11-24 08:07:09 ERROR authentication failure for user01
2026-11-24 08:10:30 INFO root checked system status
2026-11-24 08:12:18 WARNING disk usage reached 75 percent
2026-11-24 08:15:02 ERROR service ssh failed to start
2026-11-24 08:18:27 INFO user01 opened a session
2026-11-24 08:20:51 INFO scheduled backup started by root
2026-11-24 08:23:16 WARNING unusual access pattern detected
2026-11-24 08:25:39 ERROR permission denied while accessing archive
2026-11-24 08:28:04 INFO user01 closed an application
2026-11-24 08:30:22 INFO root updated package database
2026-11-24 08:33:47 WARNING network latency above threshold
2026-11-24 08:36:11 ERROR database connection timeout
2026-11-24 08:39:55 INFO system monitoring active
2026-11-24 08:42:08 WARNING temporary directory nearly full
2026-11-24 08:45:33 INFO user01 requested a report
2026-11-24 08:48:19 ERROR unauthorized operation blocked for user01
2026-11-24 08:51:40 INFO root completed maintenance
LOGS
echo "2026-11-24 08:54:03 INFO log collection completed by user01" >> "${LOG_FILE}"

echo "=== Lines containing ERROR ==="
grep "ERROR" "${LOG_FILE}" || true

echo
echo "=== Lines mentioning root or user01 ==="
grep -E "root|user01" "${LOG_FILE}" || true

echo
echo "=== Save ERROR matches and view with less ==="
echo "The report is being written to ${REPORT}"
# tee saves the matching lines while less provides interactive viewing.
grep "ERROR" "${LOG_FILE}" | tee "${REPORT}" | less

echo
echo "=== First five lines ==="
head -n 5 "${LOG_FILE}"

echo
echo "=== Last five lines ==="
tail -n 5 "${LOG_FILE}"

echo
echo "=== Full log ==="
cat "${LOG_FILE}"

echo
echo "Created: ${LOG_FILE}"
echo "Created: ${REPORT}"
