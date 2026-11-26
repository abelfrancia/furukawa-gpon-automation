#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
bash "${REPO_ROOT}/src/database/db_exec.sh" "SELECT idCliente, nomeCliente, planoCliente, statusCliente, oltCliente, poltCliente, onuCliente, macCliente FROM clientes;"
