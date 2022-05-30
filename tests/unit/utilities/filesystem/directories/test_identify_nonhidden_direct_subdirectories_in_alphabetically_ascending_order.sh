#!/bin/bash

. "$(dirname ${BASH_SOURCE})/../../../../../utilities/fail.sh"
. "$(dirname ${BASH_SOURCE})/../../../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname ${BASH_SOURCE})/../../../../../utilities/filesystem/directories/identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order.sh"
. "$(dirname ${BASH_SOURCE})/../../../../utilities/assert.sh"

main() {
  assert 255 "Invalid directory" identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "foo" "bar"

  local temporary_directory_path
  temporary_directory_path=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  assert 0 "" identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "${temporary_directory_path}"
  local -r foo_subdirectory="${temporary_directory_path}/foo"
  mkdir -p "${foo_subdirectory}" || fail "Unable to create directory: ${foo_subdirectory}"

  assert 0 "${foo_subdirectory}" identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "${temporary_directory_path}"

  local -r bar_subdirectory="${temporary_directory_path}/bar"
  mkdir -p "${bar_subdirectory}" || fail "Unable to create directory: ${bar_subdirectory}"

  assert 0 "${bar_subdirectory}${foo_subdirectory}" identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "${temporary_directory_path}"
}

main
