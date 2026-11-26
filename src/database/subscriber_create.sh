#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
read -rp "Full Name: " raw_nome; read -rp "CPF: " raw_cpf; read -rp "Address: " raw_ende
read -rp "Phone: " raw_fone; read -rp "Email: " raw_mail; read -rp "Plan: " raw_plano
read -rp "Status [ATIVO]: " raw_stat; read -rp "OLT: " raw_olt; read -rp "PON Port: " raw_polt
read -rp "ONU ID: " raw_onu; read -rp "ONU MAC: " raw_mac
SQL="INSERT INTO clientes (nomeCliente, cpfCliente, endCliente, contatoCliente, emailCliente, planoCliente, statusCliente, oltCliente, poltCliente, onuCliente, macCliente) VALUES ('$(sanitize_sql_input "${raw_nome}")','$(sanitize_sql_input "${raw_cpf}")','$(sanitize_sql_input "${raw_ende}")','$(sanitize_sql_input "${raw_fone}")','$(sanitize_sql_input "${raw_mail}")','$(sanitize_sql_input "${raw_plano}")','$(sanitize_sql_input "${raw_stat:-ATIVO}")','$(sanitize_sql_input "${raw_olt}")','$(sanitize_sql_input "${raw_polt}")','$(sanitize_sql_input "${raw_onu}")','$(sanitize_sql_input "${raw_mac}")');"
bash "${REPO_ROOT}/src/database/db_exec.sh" "${SQL}"
