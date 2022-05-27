#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/validate_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../utilities/assert.sh"

main() {
  assert 255 "Expected a single argument" validate_directory
  assert 255 "Expected a single argument" validate_directory "foo" "bar"
  assert 255 "foo does not exist" validate_directory "foo"

  local temp_directory
  temp_directory=$(create_temporary_directory)

  local -r temp_subdirectory="${temp_directory}/foo"
  mkdir -p "${temp_subdirectory}" || fail "Could not create subdirectory ${temp_subdirectory}"

  local temp_file_path 
  temp_file_path="${temp_subdirectory}/foo"
  touch "${temp_file_path}" || fail "Could not create temp file: ${temp_file_path}"
  assert 255 "${temp_file_path} is not a directory" validate_directory "${temp_file_path}"

  assert 0 "${temp_subdirectory}" validate_directory "${temp_subdirectory}"
}

main
