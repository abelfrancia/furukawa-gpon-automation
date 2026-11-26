#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "${REPO_ROOT}/config/settings.sh"
[[ -f "$1" ]] && [[ -n "${REMOTE_LOG_DEST:-}" ]] && scp -o StrictHostKeyChecking=accept-new "$1" "${REMOTE_LOG_DEST}"
