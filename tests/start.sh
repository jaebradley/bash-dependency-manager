#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/utilities/execute_test_file.sh";

main() {
  if [[ "1" != "$#" ]]; then fail "Expected test directory path as a single argument instead of '$@'"; fi

  local -r test_directory_path="$1"
  if [[ ! -d "${test_directory_path}" ]]; then fail "${test_directory_path} is not a directory"; fi

  find "${test_directory_path}" -type f -name "test_*.sh" -print0 | \
    sort --zero-terminated | \
    while IFS= read -r -d '' file
    do 
      execute_test_file "$file"
    done
}

main "$@"
