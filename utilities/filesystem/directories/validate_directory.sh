#!/bin/bash

function validate_directory() {
  if [[ "1" != "$#" ]]; then printf "Expected a directory path as a single argument\n" && return 255; fi

  local -r directory_path="$1"

  if [[ ! -e "${directory_path}" ]]; then printf "${directory_path} does not exist\n" && return 255; fi
  if [[ ! -d "${directory_path}" ]]; then printf "${directory_path} is not a directory\n" && return 255; fi

  printf "${directory_path}"
}
