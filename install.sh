#!/bin/bash/

. "$(dirname "${BASH_SOURCE}")/utilities/operating/system/validate_darwin.sh"
. "$(dirname "${BASH_SOURCE}")/utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/installation/install_dependencies.sh"

install() {
  if [[ "1" != "$#" ]]; then fail "Expected a single argument representing the directory to install dependencies in"; fi
  if [[ "0" != "$(validate_darwin)" ]]; then fail "Operating system is not Darwin"; fi

  install_dependencies "$@"
}

install "$@"
