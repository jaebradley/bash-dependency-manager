#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../utilities/fail.sh"

assert() {
  local -r arguments="$@"
  local -r expected_result_code="$1"
  local -r expected_standard_output="$2"

  shift
  shift

  local standard_output
  standard_output=$("$@")

  local -r result_code="$?"

  if [[ "${expected_result_code}" != "${result_code}" ]]
  then
    fail "Expected result code '${expected_result_code}' but got '${result_code}' instead on line ${LINENO} for test with args ${arguments} and standard output '${standard_output}'"
  fi

  if [[ "${expected_standard_output}" != "${standard_output}" ]]
  then
    fail "Expected standard output of '${expected_standard_output}' but got '${standard_output}' instead on line ${LINENO} for test with args ${arguments}"
  fi
}

