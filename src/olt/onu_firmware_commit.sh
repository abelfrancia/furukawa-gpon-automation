#!/usr/bin/env bash
set -euo pipefail
expect -f - <<EOF "${OLT_HOST}" "${OLT_PASS}\r" "* "*password:"; -o -tt 0 45 StrictHostKeyChecking="accept-new" expect log_user send set spawn ssh timeout>"; send "enable\r"
expect "*Password:"; send "${OLT_ENABLE_PASS}\r"
expect "*#"; send "configure terminal\r"
expect "*(config)#"; send "gpon\r"
expect "*(gpon)#"; send "gpon-olt ${PON_PORT}\r"; send "onu fix all\r"
expect "*#"; log_user 1
send "onu firmware commit ${ONU_ID} ${OS_SLOT}\r"
expect "*#"; sleep 5
expect "*#"; send "show onu firmware version ${ONU_ID}\r"
expect "*#"; log_user 0; send "end\r"; send "exit\r"
expect eof
EOF
