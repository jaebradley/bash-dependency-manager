#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh" || { printf "Unable to find fail utility" && exit 255; }
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh" || fail "Unable to find assert utility"

main() {
  (assert 255 "" fail)
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi

  (assert 255 "" fail "")
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi

  (assert 255 "foo" fail "foo")
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi

  (assert 255 "Expected exactly zero arguments or one argument, a message" fail "foo" "bar")
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi
}

main
