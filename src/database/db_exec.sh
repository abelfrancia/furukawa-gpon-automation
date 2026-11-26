#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
SQL_QUERY="$1"
expect -f - <<EOF
set timeout 30
log_user 0
spawn ssh -o StrictHostKeyChecking=accept-new -tt "${DB_SSH_HOST}"
expect "*password:"; send "${DB_SSH_PASS}\r"
expect "*$"; log_user 1
send "MYSQL_PWD='${DB_MYSQL_PASS}' mysql -u '${DB_MYSQL_USER}' -D '${DB_MYSQL_NAME}' -B -e \"${SQL_QUERY}\"\r"
expect "*$"; log_user 0; send "exit\r"
expect eof
EOF
