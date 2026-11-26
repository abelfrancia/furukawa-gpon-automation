#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
TARGET_ID="$(sanitize_sql_input "$1")"
ROW="$(bash "${REPO_ROOT}/src/database/db_exec.sh" "SELECT nomeCliente, oltCliente, poltCliente, onuCliente, macCliente, contatoCliente, emailCliente FROM clientes WHERE idCliente = ${TARGET_ID} LIMIT 1;" | tr -d '\r' | grep -v '^MYSQL_PWD=' | tail -n 1)"
[[ -z "${ROW}" ]] && { log_error "Subscriber ${TARGET_ID} not found."; exit 1; }
IFS=$'\t' read -r CLI_NAME OLT_OPT PON_PORT ONU_ID CLI_MAC CLI_PHONE CLI_EMAIL <<< "${ROW}"
export CLI_NAME="${CLI_NAME// /_}" OLT_OPT PON_PORT ONU_ID CLI_MAC CLI_PHONE CLI_EMAIL
