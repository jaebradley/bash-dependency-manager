#!/bin/bash

 set -o pipefail

. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/calculate_directory_md5_hash.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/filesystem/directories/create_temporary_directory.sh"

assert() {
  local -r expected_result_code="$1"
  local -r expected_standard_output="$2"

  shift
  shift

  local standard_output
  standard_output=$(calculate_directory_md5_hash "$@")

  local -r result_code="$?"

  if [[ "${expected_result_code}" != "${result_code}" ]]
  then
    fail "Expected '${expected_result_code}' but got '${result_code}' instead on line ${LINENO} for test with args $@ and standard output '${standard_output}'"
  fi

  if [[ "${expected_standard_output}" != "${standard_output}" ]]
  then
    fail "Expected '${expected_standard_output}' but got '${standard_output}' instead on line ${LINENO} for test with args $@"
  fi
}

main() {
  assert 255 "Unable to validate directory"
  assert 255 "Unable to validate directory" "foo" "bar"
  assert 255 "Unable to validate directory" "foo"

  local temp_directory
  temp_directory=$(create_temporary_directory)

  local -r temp_subdirectory="${temp_directory}/foo"
  mkdir -p "${temp_subdirectory}" || fail "Could not create subdirectory"

  local temp_file_path 
  temp_file_path="${temp_subdirectory}/foo"

  touch "${temp_file_path}" || fail "Could not create temp file: ${temp_file_path}"

  assert 0 "71abdd93fa472ad6705abf8768e42444" "${temp_subdirectory}"

  echo -n "foo" > "${temp_file_path}" || fail "Unable to append text to temp file ${temp_file_path}"
  assert 0 "047fa30c5893354246cdd1597fa5e300" "${temp_subdirectory}"

}

echo "Starting tests in ${BASH_SOURCE}"
main
echo "Finishing tests in ${BASH_SOURCE}"
