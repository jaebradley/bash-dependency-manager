#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../fail.sh" || { printf "Could not import error utility\n" && exit 255; }
. "$(dirname "${BASH_SOURCE}")/../../log_error.sh" || fail "Could not import error logging utility"

. "$(dirname "${BASH_SOURCE}")/validate_directory.sh" || fail "Could not import utility on line ${LINENO}"

function calculate_directory_name_md5_hash() {
  local directory_path
  directory_path=$(validate_directory "$@")
  if [[ "0" != "$?" ]]; then log_error "Invalid directory path" && return 255; fi

  (set -o pipefail && printf "${directory_path}" | xargs basename | md5 -q)
}
