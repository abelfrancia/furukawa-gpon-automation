#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
read -rp "Subscriber ID to delete: " raw_id
sub_id="$(sanitize_sql_input "${raw_id}")"
[[ ! "${sub_id}" =~ ^[0-9]+$ ]] && { log_error "Numeric ID required."; exit 1; }
read -rp "Confirm delete ID ${sub_id}? [y/N]: " c
[[ "${c,,}" != "y" ]] && exit 0
bash "${REPO_ROOT}/src/database/db_exec.sh" "DELETE FROM clientes WHERE idCliente=${sub_id};"
