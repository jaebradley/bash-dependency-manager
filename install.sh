#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/utilities/operating/system/validate_darwin.sh"
. "$(dirname "${BASH_SOURCE[0]}")/utilities/fail.sh"
. "$(dirname "${BASH_SOURCE[0]}")/installation/install_dependencies.sh"

install() {
  if [[ "1" != "$#" ]]; then fail "Expected a single argument representing the directory to install dependencies in"; fi

  validate_darwin
  if [[ ! $? ]]; then fail "Operating system is not Darwin"; fi

  install_dependencies "$@"
}

install "$@"
