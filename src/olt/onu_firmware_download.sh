#!/usr/bin/env bash
set -euo pipefail
expect -f - <<EOF "${OLT_HOST}" "${OLT_PASS}\r" "* "*password:"; -o -tt 0 300 StrictHostKeyChecking="accept-new" expect log_user send set spawn ssh timeout>"; send "enable\r"
expect "*Password:"; send "${OLT_ENABLE_PASS}\r"
expect "*#"; send "terminal monitor\r"
expect "*#"; send "configure terminal\r"
expect "*(config)#"; send "gpon\r"
expect "*(gpon)#"; send "gpon-olt ${PON_PORT}\r"
expect "*#"; log_user 1
send "show onu firmware version ${ONU_ID}\r"
expect "*#"; send "onu fix all\r"; send "onu firmware download ${ONU_ID} ${FIRMWARE_FILE}\r"
expect "*#"; sleep 220
expect "*#"; send "show onu firmware version ${ONU_ID}\r"
expect "*#"; log_user 0; send "end\r"; send "exit\r"
expect eof
EOF
