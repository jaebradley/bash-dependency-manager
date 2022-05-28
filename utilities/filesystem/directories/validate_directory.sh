#!/bin/bash

function validate_directory() {
  if [[ "1" != "$#" ]]; then echo "Expected a directory path as a single argument" && return 255; fi

  local -r directory_path="$1"

  if [[ ! -e "${directory_path}" ]]; then echo "${directory_path} does not exist" && return 255; fi
  if [[ ! -d "${directory_path}" ]]; then echo "${directory_path} is not a directory" && return 255; fi

  echo "${directory_path}"
}
