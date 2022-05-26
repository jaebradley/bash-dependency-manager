#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/calculate_directory_files.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../utililties/assert.sh"

main() {
  local current_directory
  current_directory=$(pwd)
  if [[ "0" != "$?" ]]; then fail "Could not identify current directory"; fi

  assert 0 "${current_directory}" pwd
  assert 255 "Unable to validate directory" calculate_directory_files "foo" "bar"
  assert 0 "${current_directory}" pwd

  local temp_directory
  temp_directory=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  local -r temp_file_path="${temp_directory}/foo"
  touch "${temp_file_path}" || fail "Could not create temp file: ${temp_file_path}"


  assert 0 "${current_directory}" pwd
  assert 0 "./foo" calculate_directory_files "${temp_directory}"
  assert 0 "${current_directory}" pwd

  local -r another_temp_file_path="${temp_directory}/bar"
  touch "${another_temp_file_path}" || fail "Could not create temp file: ${another_temp_file_path}"

  assert 0 "${current_directory}" pwd
  assert 0 "./bar./foo" calculate_directory_files "${temp_directory}"
  assert 0 "${current_directory}" pwd
}

echo "Starting tests in ${BASH_SOURCE}"
main
echo "Finishing tests in ${BASH_SOURCE}"
