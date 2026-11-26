#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
DATE_TAG="$(date +'%Y%m%d')"
INV_FILE="${1:-${LOG_ROOT}/inventory_${DATE_TAG}/ONULIST-${DATE_TAG}.log}"
[[ ! -f "${INV_FILE}" ]] && bash "${REPO_ROOT}/src/olt/onu_inventory.sh"
awk -F'|' -v warn="${OPTICAL_RX_WARN_MIN:--26}" -v crit="${OPTICAL_RX_CRIT_MIN:--28}" '
BEGIN { printf "%-20s | %-12s | %-12s\n", "ONU MAC", "RX POWER", "STATUS" }
/dBm/ {
    mac=$4; gsub(/ /,"",mac); rx=$6; gsub(/ |dBm/,"",rx); v=rx+0
    st=(v<=crit?"CRITICAL":(v<=warn?"WARNING":"OK"))
    printf "%-20s | %8.2f dBm | %-12s\n", mac, v, st
}' "${INV_FILE}"
