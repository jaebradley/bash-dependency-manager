#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../fail.sh"
. "$(dirname "${BASH_SOURCE}")/validate_directory.sh"

function identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order() {
  local directory_path
  directory_path=$(validate_directory "$@")
  if [[ "0" != "$?" ]]; then echo "Invalid directory" && return 255; fi

  (set -o pipefail && find "${directory_path}" -not -path "*/.*" -type d -mindepth 1 -maxdepth 1 -print0 | sort --zero-terminated)
}
