#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/calculate_directory_name_md5_hash.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../utilities/assert.sh"

main() {
  assert 255 "Invalid directory path" calculate_directory_name_md5_hash
  assert 255 "Invalid directory path" calculate_directory_name_md5_hash "foo" "bar"
  assert 255 "Invalid directory path" calculate_directory_name_md5_hash "foo"

  local temp_directory
  temp_directory=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Could not create a temporary directory"; fi

  local -r temp_subdirectory="${temp_directory}/foo"
  mkdir -p "${temp_subdirectory}" || fail "Could not create subdirectory ${temp_subdirectory}"
  assert 0 "d3b07384d113edec49eaa6238ad5ff00" calculate_directory_name_md5_hash "${temp_subdirectory}"

  local -r temp_nested_subdirectory="${temp_subdirectory}/foo"
  mkdir -p "${temp_nested_subdirectory}" || fail "Could not create subdirectory ${temp_nested_subdirectory}"
  assert 0 "d3b07384d113edec49eaa6238ad5ff00" calculate_directory_name_md5_hash "${temp_nested_subdirectory}"
}

main
