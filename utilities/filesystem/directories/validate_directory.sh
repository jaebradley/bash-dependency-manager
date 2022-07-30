#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../log_error.sh" || { printf "Could not import error logging utility\n" && exit 255; }

function validate_directory() {
  if [[ "1" != "$#" ]]; then log_error "Expected a directory path as a single argument" && return 255; fi

  local -r directory_path="$1"

  if [[ ! -e "${directory_path}" ]]; then log_error "${directory_path} does not exist" && return 255; fi
  if [[ ! -d "${directory_path}" ]]; then log_error "${directory_path} is not a directory" && return 255; fi

  printf "${directory_path}"
}
