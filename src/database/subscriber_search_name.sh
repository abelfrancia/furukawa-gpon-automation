#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
read -rp "Subscriber name: " raw_name
bash "${REPO_ROOT}/src/database/db_exec.sh" "SELECT idCliente, nomeCliente, planoCliente, statusCliente, oltCliente, poltCliente, onuCliente, macCliente FROM clientes WHERE nomeCliente LIKE '%$(sanitize_sql_input "${raw_name}")%';"
