#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../fail.sh"

function identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order() {
  if [[ "1" != "$#" ]]
  then
    fail "Expected a single argument"
  fi

  local directory="$1"

  if [[ ! -e "${directory}" ]]
  then
    fail "Path ${directory} does not exist"
  fi

  if [[ ! -d "${directory}" ]]
  then
    fail "Path ${directory} is not a directory"
  fi

  find "${directory}" -not -path "./.*" -type d -mindepth 1 -maxdepth 1 -print0 | sort --zero-terminated
}
