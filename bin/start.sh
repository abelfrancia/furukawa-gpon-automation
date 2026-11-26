#!/usr/bin/env bash
# Furukawa GPON Automation Suite - Main Entrypoint - Abel Luis Francia
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"

echo -e "${C_WHITE}======================================================================${C_RESET}"
echo -e "${C_CYAN}       FURUKAWA GPON AUTOMATION & NETOPS SUITE                        ${C_RESET}"
echo -e "${C_YELLOW}                                            by Abel Luis Francia      ${C_RESET}"
echo -e "${C_WHITE}======================================================================${C_RESET}"
echo "  [1] OLT Maintenance & Provisioning Console"
echo "  [2] Register New Subscriber (DB)"
echo "  [3] List All Subscribers (DB)"
echo "  [4] Inventory All ONUs Across OLT Fleet"
echo "  [5] Search Subscriber by Name (DB)"
echo "  [6] Search Subscriber by ID or MAC (DB)"
echo "  [7] Update Subscriber Record (DB)"
echo "  [8] Delete Subscriber Record (DB)"
echo "  [9] Optical RX Signal Health Audit (dBm)"
echo " [10] XenServer Hypervisor Backup Log Audit"
echo "  [0] Exit"
read -rp "Select an option: " CHOICE

case "${CHOICE}" in
    1)  bash "${REPO_ROOT}/src/olt/olt_manager.sh" ;;
    2)  bash "${REPO_ROOT}/src/database/subscriber_create.sh" ;;
    3)  bash "${REPO_ROOT}/src/database/subscriber_list.sh" ;;
    4)  bash "${REPO_ROOT}/src/olt/onu_inventory.sh" ;;
    5)  bash "${REPO_ROOT}/src/database/subscriber_search_name.sh" ;;
    6)  bash "${REPO_ROOT}/src/database/subscriber_search_id.sh" ;;
    7)  bash "${REPO_ROOT}/src/database/subscriber_update.sh" ;;
    8)  bash "${REPO_ROOT}/src/database/subscriber_delete.sh" ;;
    9)  bash "${REPO_ROOT}/src/analytics/optical_signal_audit.sh" ;;
    10) bash "${REPO_ROOT}/src/hypervisor/xen_backup_audit.sh" ;;
    0)  exit 0 ;;
    *)  log_error "Invalid option: '${CHOICE}'"; exit 1 ;;
esac
