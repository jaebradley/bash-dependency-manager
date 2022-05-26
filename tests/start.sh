#!/bin/bash

main() {
  if [[ "1" != "$#" ]]
  then
    echo "$?"
    echo "Expected a single argument" && exit 255
  fi

  local -r test_directory_path="$1"
  if [[ ! -d "${test_directory_path}" ]]
  then
    echo "${test_directory_path} is not a test directory" && exit 255
  fi

  find "${test_directory_path}" -type f -name "test_*.sh" -exec bash -c {} ';'
}

main "$1"
