#!/usr/bin/env bash
# Furukawa OLT Maintenance & Provisioning Orchestrator - Abel Luis Francia
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"

echo -e "\n${C_CYAN}#### FURUKAWA OLT MAINTENANCE CONSOLE ####${C_RESET}"
echo "  [1] Full Subscriber Diagnostic (OLT Info + ARP/Syslog + Ping Probe)"
echo "  [2] MTR Path & Packet Loss Analysis"
echo "  [3] Block / Unblock ONU Service"
echo "  [4] Upgrade / Change ONU Bandwidth Profile (G400R / G420W / ONT100 / DM984)"
echo "  [5] Decommission / Cancel Subscriber ONU"
echo "  [6] Download ONU Firmware Image"
echo "  [7] Commit ONU OS Partition (os1 / os2)"
echo "  [8] Reboot / Reset Remote ONU"
echo "  [9] Interactive OLT GPON CLI Session"
echo " [10] Clear OLT SNMP Alarm History & Report"
read -rp "Execute action [1-10]: " ACTION

[[ "${ACTION}" == "9" ]] && exec bash "${REPO_ROOT}/src/olt/interactive_cli.sh"

read -rp "Subscriber ID (enter 0 for manual OLT/PON/ONU input): " SUB_ID
export ATV="" CMD="" FIRMWARE_FILE="" OS_SLOT="" TARGET_IP=""

case "${ACTION}" in
    1) ATV="TRATATIVA" ;;
    2) ATV="MTR"; read -rp "Target CPE/Host IPv4: " TARGET_IP ;;
    3) read -rp "[1] Block  [2] Unblock: " b; [[ "${b}" == "1" ]] && { ATV="BLOCK"; CMD="block"; } || { ATV="UNBLOCK"; CMD="unblock"; } ;;
    4)
        echo "  [1] G400R 50M  [2] G400R 100M  [3] G420W 50M  [4] G420W 100M"
        echo "  [5] ONT100 50M [6] ONT100 100M [7] DM984 50M  [8] DM984 100M"
        read -rp "Profile [1-8]: " p
        case "${p}" in
            1) ATV="UP400R_50M"; CMD="G400R_50M" ;; 2) ATV="UP400R_100M"; CMD="G400R_100M" ;;
            3) ATV="UP420W_50M"; CMD="G420_50M" ;;  4) ATV="UP420W_100M"; CMD="G420_100M" ;;
            5) ATV="UP100_50M";  CMD="50M" ;;       6) ATV="UP100_100M";  CMD="100M" ;;
            7) ATV="UPDM984_50M";CMD="DM984_50M" ;; 8) ATV="UPDM984_100M";CMD="DM984_100M" ;;
            *) log_error "Invalid profile"; exit 1 ;;
        esac ;;
    5) ATV="CANCEL" ;;
    6)
        ATV="UPFIRMW"
        echo "  [1] G400R (3.03p2-1146)  [2] G420W (3.03p2-1146)  [3] ONT100 (v1.1.9)"
        read -rp "Firmware [1-3]: " fw
        case "${fw}" in
            1) FIRMWARE_FILE="G_ONU_N_3.03p2-1146.01.G400R.x" ;;
            2) FIRMWARE_FILE="G_ONU_N_3.03p2-1146.01.G420W.x" ;;
            3) FIRMWARE_FILE="G_ONU_ONT100_V1.1.9-R01B010D2c7afd42.upf" ;;
            *) log_error "Invalid firmware"; exit 1 ;;
        esac ;;
    7) ATV="COMMIT"; read -rp "[1] os1  [2] os2: " o; [[ "${o}" == "1" ]] && OS_SLOT="os1" || OS_SLOT="os2" ;;
    8) ATV="RESTART" ;;
    10) ATV="CLEARSNMP" ;;
    *) log_error "Invalid action"; exit 1 ;;
esac

if [[ "${SUB_ID}" =~ ^[0-9]+$ ]] && [[ "${SUB_ID}" -gt 0 ]]; then
    source "${REPO_ROOT}/src/database/subscriber_fetch_vars.sh" "${SUB_ID}"
else
    read -rp "[1] ${OLT_PRIMARY_CODE}  [2] ${OLT_SECONDARY_CODE}: " OLT_OPT
    read -rp "Subscriber Name: " CLI_NAME
    read -rp "GPON PON Port (e.g. 1/1): " PON_PORT
    read -rp "ONU ID: " ONU_ID
    export SUB_ID="MANUAL" CLI_MAC="" CLI_PHONE="N/A" CLI_EMAIL="N/A"
fi

resolve_olt_target "${OLT_OPT}"
DATE_TAG="$(date +'%Y%m%d')"
mkdir -p "${LOG_ROOT}/olt_${DATE_TAG}"
LOG_FILE="${LOG_ROOT}/olt_${DATE_TAG}/${ATV}-${OLT_CODE}-${CLI_NAME}_${PON_PORT//\//-}_ONU${ONU_ID}_${DATE_TAG}.log"

{
    echo "=== Started: $(date '+%Y-%m-%d %H:%M:%S') | Operator: Abel Luis Francia ==="
    case "${ACTION}" in
        1)
            bash "${REPO_ROOT}/src/olt/onu_diagnostic.sh"
            [[ -z "${CLI_MAC:-}" ]] && export CLI_MAC="$(grep -A2 "MAC ADDRESS" "${LOG_FILE}" | tr -d ' ' | cut -d'|' -f4 | sed -n '2p' || true)"
            bash "${REPO_ROOT}/src/olt/olt_syslog_arp.sh"
            [[ -z "${TARGET_IP:-}" ]] && export TARGET_IP="$(grep -A1 "do show arp" "${LOG_FILE}" | awk 'NR==2 {print $1}' || true)"
            [[ -n "${TARGET_IP:-}" ]] && bash "${REPO_ROOT}/src/diagnostics/probe_speedtest.sh"
            ;;
        2) bash "${REPO_ROOT}/src/diagnostics/probe_mtr.sh" ;;
        3) bash "${REPO_ROOT}/src/olt/onu_block_unblock.sh" ;;
        4) bash "${REPO_ROOT}/src/olt/onu_profile_upgrade.sh" ;;
        5) bash "${REPO_ROOT}/src/olt/onu_decommission.sh" ;;
        6) bash "${REPO_ROOT}/src/olt/onu_firmware_download.sh" ;;
        7) bash "${REPO_ROOT}/src/olt/onu_firmware_commit.sh" ;;
        8) bash "${REPO_ROOT}/src/olt/onu_restart.sh" ;;
        10) bash "${REPO_ROOT}/src/olt/olt_snmp_clear.sh" ;;
    esac
    echo "=== Ended: $(date '+%Y-%m-%d %H:%M:%S') ==="
} >> "${LOG_FILE}" 2>&1

[[ "${ENABLE_REMOTE_LOG_SYNC:-false}" == "true" ]] && bash "${REPO_ROOT}/src/lib/sync_logs.sh" "${LOG_FILE}"
open_log_viewer "${LOG_FILE}"
