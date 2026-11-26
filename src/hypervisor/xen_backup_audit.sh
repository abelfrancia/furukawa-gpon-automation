#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
DATE_TAG="$(date +'%Y%m%d')"
mkdir -p "${LOG_ROOT}/xen_backup_${DATE_TAG}"
for entry in ${XEN_HOSTS}; do
    NODE_NAME="${entry%%:*}"; NODE_IP="${entry##*:}"
    NODE_LOG="${LOG_ROOT}/xen_backup_${DATE_TAG}/VER_BKP_${NODE_NAME}-${DATE_TAG}.log"
    {
        expect -f - <<EOF "${XEN_SSH_PASS}\r" "${XEN_SSH_USER}@${NODE_IP}" "*#"; "*password:"; "cat "exit\r" ${XEN_BACKUP_LOG_DIR}/VmBackup-${NODE_NAME}.log\r" -o -tt 0 0; 1; 60 EOF StrictHostKeyChecking="accept-new" eof expect log_user send set spawn ssh timeout }> "${NODE_LOG}" 2>&1
    log_ok "Saved: ${NODE_LOG}"
done
