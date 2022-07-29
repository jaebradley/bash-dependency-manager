#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/validate_directory.sh"

function calculate_file_names_md5_hash() {
  if [[ "1" != "$#" ]]; then printf "Expected a single directory path\n" && return 255; fi
  (set -o pipefail && validate_directory "$1" | xargs -I {} find {} -type f -maxdepth 1 -mindepth 1 -print0 | sort --zero-terminated | md5 -q)
}
