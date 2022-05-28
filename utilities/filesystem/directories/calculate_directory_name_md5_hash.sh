#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/validate_directory.sh"

function calculate_directory_name_md5_hash() {
  local directory_path
  directory_path=$(validate_directory "$@")
  if [[ "0" != "$?" ]]; then echo "Invalid directory path" && return 255; fi

  (set -o pipefail && echo -n "${directory_path}" | xargs basename | md5 -q)
}
