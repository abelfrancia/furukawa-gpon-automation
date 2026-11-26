#!/usr/bin/env bash
set -euo pipefail
expect -f - <<EOF
set timeout 60
log_user 0
spawn ssh -o StrictHostKeyChecking=accept-new -tt "${PROBE_SSH_HOST}"
expect "*password:"; send "${PROBE_SSH_PASS}\r"
expect "*$"; log_user 1; send "ping -i 0.1 -c 128 ${TARGET_IP}\r"
expect "*$"; log_user 0; send "exit\r"
expect eof
EOF
