#!/bin/bash

set -e

. "$(dirname ${BASH_SOURCE})/../../../../../utilities/fail.sh"
. "$(dirname ${BASH_SOURCE})/../../../../../utilities/filesystem/directories/identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order.sh"

function test_multiple_arguments_exits_with_nonzero_exit_code() {
  identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "foo" "bar"
  "0" == "$?" || fail "Expected non-zero exit code"
}

test_multiple_arguments_exits_with_nonzero_exit_code
