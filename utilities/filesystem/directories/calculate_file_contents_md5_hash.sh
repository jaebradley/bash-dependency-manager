#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/calculate_directory_files.sh"
. "$(dirname "${BASH_SOURCE}")/validate_directory.sh"

function calculate_directory_file_contents_md5_hash() {
  if [[ "1" != "$#" ]]; then echo "Expected a single directory path" && return 255; fi
  (set +o pipefail && validate_directory "$1" | xargs -I {} find {} -type f -maxdepth 1 -mindepth 1 -print0 | sort --zero-terminated | xargs -0 md5 -q | md5 -q)
}

