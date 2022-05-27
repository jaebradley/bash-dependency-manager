#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/calculate_directory_md5_hash.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh"

main() {
  assert 255 "Expected a single argument representing the path to a directory" calculate_directory_md5_hash
  assert 255 "Expected a single argument representing the path to a directory" calculate_directory_md5_hash "foo" "bar"
  assert 255 "Unable to validate directory" calculate_directory_md5_hash "foo"

  local temp_directory
  temp_directory=$(create_temporary_directory)

  local -r temp_subdirectory="${temp_directory}/foo"
  mkdir -p "${temp_subdirectory}" || fail "Could not create subdirectory"

  local temp_file_path 
  temp_file_path="${temp_subdirectory}/foo"

  touch "${temp_file_path}" || fail "Could not create temp file: ${temp_file_path}"

  assert 0 "71abdd93fa472ad6705abf8768e42444" calculate_directory_md5_hash "${temp_subdirectory}"

  echo -n "foo" > "${temp_file_path}" || fail "Unable to append text to temp file ${temp_file_path}"
  assert 0 "047fa30c5893354246cdd1597fa5e300" calculate_directory_md5_hash "${temp_subdirectory}"

}

main
