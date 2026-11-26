#!/usr/bin/env bash
set -euo pipefail
expect -f - <<EOF "${OLT_HOST}" "${OLT_PASS}\r" "* "*password:"; -o -tt 0 30 StrictHostKeyChecking="accept-new" expect log_user send set spawn ssh timeout>"; send "enable\r"
expect "*Password:"; send "${OLT_ENABLE_PASS}\r"
expect "*#"; send "configure terminal\r"
expect "*(config)#"; log_user 1
send "snmp clear alarm-history\r"
expect "*(config)#"; send "snmp clear alarm-report\r"
expect "*#"; log_user 0; send "end\r"; send "exit\r"
expect eof
EOF
