#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../fail.sh"

function identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order() {
  if [[ "1" != "$#" ]]
  then
    echo "Expected a single argument"
    return 255
  fi

  local directory="$1"

  if [[ ! -e "${directory}" ]]
  then
    echo "Path ${directory} does not exist"
    return 255
  fi

  if [[ ! -d "${directory}" ]]
  then
    echo "Path ${directory} is not a directory"
    return 255
  fi

  find "${directory}" -not -path "./.*" -type d -mindepth 1 -maxdepth 1 -print0 | sort --zero-terminated
}
