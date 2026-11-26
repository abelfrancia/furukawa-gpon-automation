#!/usr/bin/env bash
# Central Configuration Loader & Shared Helpers - Abel Luis Francia
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"

if [[ -f "${ENV_FILE}" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "${ENV_FILE}"
    set +a
else
    echo "[ERROR] '.env' not found. Run: cp .env.example .env" >&2
    exit 1
fi

LOG_ROOT="${REPO_ROOT}/logs"
mkdir -p "${LOG_ROOT}"

export C_RESET='\033[0m' C_CYAN='\033[01;36m' C_YELLOW='\033[01;33m'
export C_GREEN='\033[01;32m' C_RED='\033[01;31m' C_WHITE='\033[01;37m'

log_info()  { echo -e "${C_CYAN}[INFO]${C_RESET} $*"; }
log_ok()    { echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
log_warn()  { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
log_error() { echo -e "${C_RED}[ERROR]${C_RESET} $*" >&2; }

resolve_olt_target() {
    local selector="${1^^}"
    case "${selector}" in
        1|"${OLT_PRIMARY_CODE^^}"|PRIMARY)
            export OLT_CODE="${OLT_PRIMARY_CODE}" OLT_HOST="${OLT_PRIMARY_HOST}"
            export OLT_PASS="${OLT_PRIMARY_PASS}" OLT_ENABLE_PASS="${OLT_PRIMARY_ENABLE_PASS}" ;;
        2|"${OLT_SECONDARY_CODE^^}"|SECONDARY)
            export OLT_CODE="${OLT_SECONDARY_CODE}" OLT_HOST="${OLT_SECONDARY_HOST}"
            export OLT_PASS="${OLT_SECONDARY_PASS}" OLT_ENABLE_PASS="${OLT_SECONDARY_ENABLE_PASS}" ;;
        *)
            log_error "Invalid OLT selector: '${selector}'"
            return 1 ;;
    esac
}

open_log_viewer() {
    local target_file="$1"
    [[ ! -f "${target_file}" ]] && return 0
    if command -v xdg-open >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
        xdg-open "${target_file}" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        open "${target_file}"
    else
        cat "${target_file}"
    fi
}

sanitize_sql_input() {
    printf '%s' "$1" | tr -d "'\";\\"
}
