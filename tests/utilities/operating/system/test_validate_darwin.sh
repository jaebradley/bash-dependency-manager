#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../utilities/operating/system/validate_darwin.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/assert.sh"

main() {
  assert 255 "Expected no arguments" validate_darwin "foo"
  assert 0 "" validate_darwin
}
