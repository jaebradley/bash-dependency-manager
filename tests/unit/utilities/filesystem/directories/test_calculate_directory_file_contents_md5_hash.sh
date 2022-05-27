#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/calculate_file_contents_md5_hash.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../utilities/assert.sh"

main() {
  local temp_directory
  temp_directory=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  pushd "${temp_directory}" > /dev/null

  assert 0 "d41d8cd98f00b204e9800998ecf8427e" calculate_file_contents_md5_hash "${temp_directory}" 
  local -r temp_file_path="${temp_directory}/foo"
  touch "${temp_file_path}" || fail "Could not create temp file: ${temp_file_path}"

  assert 0 "227bc609651f929e367c3b2b79e09d5b" calculate_file_contents_md5_hash "${temp_directory}"
  local -r another_temp_file_path="${temp_directory}/bar"
  touch "${another_temp_file_path}" || fail "Could not create temp file: ${temp_file_path}"

  assert 0 "3491c4dc96e647eea68b42ee1aa5a5d3" calculate_file_contents_md5_hash "${temp_directory}"

  local -r subdirectory_path="${temp_directory}/baz"
  mkdir -p "${subdirectory_path}" || fail "Could not create subdirectory: ${subdirectory_path}"
  assert 0 "3491c4dc96e647eea68b42ee1aa5a5d3" calculate_file_contents_md5_hash "${temp_directory}"

  local -r subdirectory_temp_file_path="${subdirectory_path}/blah"
  touch "${subdirectory_temp_file_path}" || fail "Could not create temp file: ${subdirectory_temp_file_path}"
  assert 0 "3491c4dc96e647eea68b42ee1aa5a5d3" calculate_file_contents_md5_hash  "${temp_directory}"
  popd "${temp_directory}" > /dev/null
}

main
