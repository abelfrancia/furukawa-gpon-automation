#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
read -rp "[1] ${OLT_PRIMARY_CODE}  [2] ${OLT_SECONDARY_CODE}: " OLT_OPT
resolve_olt_target "${OLT_OPT}"
read -rp "Subscriber Reference: " CLI_NAME
read -rp "GPON PON Port (e.g. 1/1): " PON_PORT
read -rp "ONU ID: " ONU_ID
DATE_TAG="$(date +'%Y%m%d')"
mkdir -p "${LOG_ROOT}/interactive_${DATE_TAG}"
LOG_FILE="${LOG_ROOT}/interactive_${DATE_TAG}/INTERACT-${OLT_CODE}-${CLI_NAME}_${DATE_TAG}.log"
expect -f - <<EOF "${LOG_FILE}" "${OLT_HOST}" "${OLT_PASS}\r" "* "*password:"; -1 -a -o -tt StrictHostKeyChecking="accept-new" expect log_file send set spawn ssh timeout>"; send "enable\r"
expect "*Password:"; send "${OLT_ENABLE_PASS}\r"
expect "*#"; send "configure terminal\r"
expect "*(config)#"; send "gpon\r"
expect "*(gpon)#"; send "gpon-olt ${PON_PORT}\r"
expect "*#"
interact
EOF
