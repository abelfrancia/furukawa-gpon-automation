#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
DATE_TAG="$(date +'%Y%m%d')"
mkdir -p "${LOG_ROOT}/inventory_${DATE_TAG}"
LOG_FILE="${LOG_ROOT}/inventory_${DATE_TAG}/ONULIST-${DATE_TAG}.log"
{
    for idx in 1 2; do
        resolve_olt_target "${idx}"
        echo "--- OLT: ${OLT_CODE} ---"
        expect -f - <<EOF "${OLT_HOST}" "${OLT_PASS}\r" "* "*password:"; -o -tt 0 45 StrictHostKeyChecking="accept-new" expect log_user send set spawn ssh timeout>"; send "enable\r"
expect "*Password:"; send "${OLT_ENABLE_PASS}\r"
expect "*#"; send "terminal length 0\r"
expect "*#"; send "configure terminal\r"
expect "*(config)#"; send "gpon\r"
expect "*(gpon)#"; log_user 1; send "show onu info\r"
expect { "*more*" { send " "; exp_continue } "*(gpon)#" { log_user 0; send "end\r"; send "exit\r" } }
expect eof
EOF
    done
} > "${LOG_FILE}" 2>&1
open_log_viewer "${LOG_FILE}"
