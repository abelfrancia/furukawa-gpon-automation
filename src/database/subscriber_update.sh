#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
read -rp "Subscriber ID: " raw_id
sub_id="$(sanitize_sql_input "${raw_id}")"
[[ ! "${sub_id}" =~ ^[0-9]+$ ]] && { log_error "Numeric ID required."; exit 1; }
read -rp "New Plan: " raw_plano; read -rp "New Status: " raw_stat; read -rp "New OLT: " raw_olt
read -rp "New PON Port: " raw_polt; read -rp "New ONU ID: " raw_onu; read -rp "New MAC: " raw_mac
SQL="UPDATE clientes SET planoCliente='$(sanitize_sql_input "${raw_plano}")', statusCliente='$(sanitize_sql_input "${raw_stat}")', oltCliente='$(sanitize_sql_input "${raw_olt}")', poltCliente='$(sanitize_sql_input "${raw_polt}")', onuCliente='$(sanitize_sql_input "${raw_onu}")', macCliente='$(sanitize_sql_input "${raw_mac}")' WHERE idCliente=${sub_id};"
bash "${REPO_ROOT}/src/database/db_exec.sh" "${SQL}"
