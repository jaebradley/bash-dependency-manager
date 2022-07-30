#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../utilities/error.sh" || { printf "Unable to find error utility" && exit 255; }
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh" || fail "Unable to find assert utility"

main() {
  (assert 255 "" error)
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi

  (assert 255 "" error "")
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi

  (assert 255 "foo" error "foo")
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi

  (assert 255 "Expected exactly zero arguments or one argument, a message" error "foo" "bar")
  if [[ "0" != "$?" ]]; then fail "Test failed on line: ${LINENO}"; fi
}

main

