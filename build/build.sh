#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE[0]}")/lint.sh"

main() {
  . "$(dirname "${BASH_SOURCE[0]}")/../install.sh" "$(dirname "${BASH_SOURCE[0]}")/../dependencies"
  if [[ ! $? ]]; then fail "Installation failed"; fi

  $(lint "$(dirname "${BASH_SOURCE[0]}")/../dependencies/.executables/shellcheck-v0.8.0/shellcheck" "$(dirname "${BASH_SOURCE[0]}")/..")
  if [[ ! $? ]]; then fail "Linting failed"; fi
}

main
