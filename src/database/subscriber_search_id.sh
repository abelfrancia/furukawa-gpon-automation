#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
read -rp "[1] Search by ID  [2] Search by ONU MAC: " mode
if [[ "${mode}" == "2" ]]; then
    read -rp "ONU MAC: " raw_mac
    bash "${REPO_ROOT}/src/database/db_exec.sh" "SELECT idCliente, nomeCliente, planoCliente, statusCliente, oltCliente, poltCliente, onuCliente, macCliente FROM clientes WHERE macCliente = '$(sanitize_sql_input "${raw_mac}")';"
else
    read -rp "Subscriber ID: " raw_id
    bash "${REPO_ROOT}/src/database/db_exec.sh" "SELECT idCliente, nomeCliente, planoCliente, statusCliente, oltCliente, poltCliente, onuCliente, macCliente FROM clientes WHERE idCliente = '$(sanitize_sql_input "${raw_id}")';"
fi
