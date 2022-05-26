#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/validate_directory.sh"

function calculate_directory_files() {
  local directory_path
  local return_code

  directory_path=$(validate_directory "$1")
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    echo "Unable to validate directory"
    return 255
  fi
  (set +o pipefail && cd "${directory_path}" && find . -type f -maxdepth 1 -mindepth 1 -print0 | sort --zero-terminated)
}

