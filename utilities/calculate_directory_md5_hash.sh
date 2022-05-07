#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/fail.sh"

# Only calculates the md5 hash of directories that consist of only regular files

function calculate_directory_md5_hash() {
  if [[ "1" != "$#" ]]
  then
    fail "Expected a single argument"
  fi

  local -r directory_path="$1"

  if [[ ! -e "${directory_path}" ]];
  then
    fail "${directory_path} does not exist"
  fi

  if [[ ! -d "${directory_path}" ]];
  then
    fail "${directory_path} is not a directory"
  fi

  find "${directory_path}" -type f -maxdepth 1 -print0 | sort --zero-terminated | xargs -0 md5 -q | md5 -q
}
