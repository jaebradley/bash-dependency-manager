#!/bin/bash

. "$(dirname ${BASH_SOURCE})/../../../../../utilities/fail.sh"
. "$(dirname ${BASH_SOURCE})/../../../../../utilities/filesystem/directories/identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order.sh"

main() {
  local output
  local result

  output=$(identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "foo" "bar")
  result="$?"
  if [[ "255" != "${result}" ]]
  then
    fail "Expected an error"
  fi

  if [[ "Expected a single argument" != ${output} ]]
  then
    fail "Expected output: 'Expected a single argument' instead of '${output}'"
  fi

  output=$(identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order)
  result="$?"
  if [[ "255" != "${result}" ]]
  then
    fail "Expected an error"
  fi

  if [[ "Expected a single argument" != ${output} ]]
  then
    fail "Expected output: 'Expected a single argument' instead of '${output}'"
  fi
}

echo "Starting tests in ${BASH_SOURCE}"
main
echo "Finishing tests in ${BASH_SOURCE}"
