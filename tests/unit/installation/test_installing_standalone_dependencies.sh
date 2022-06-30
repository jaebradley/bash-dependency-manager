#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../installation/install_dependencies.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh"

main() {
  assert 255 "Absolute installation directory specified: ." install_dependencies "."

  local temp_directory_path
  temp_directory_path=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  assert 0 "" install_dependencies "${temp_directory_path}"

  local -r first_dependency_path="${temp_directory_path}/dependencies/foo"
  mkdir -p "${first_dependency_path}" || fail "Unable to create dependency directory: ${first_dependency_path}"
  touch "${first_dependency_path}/install.sh" || fail "Unable to create installation script"
  chmod 555 "${first_dependency_path}/install.sh" || fail "Unable to create installation script"
  touch "${first_dependency_path}/source" || fail "Unable to create source"
  touch "${first_dependency_path}/target" || fail "Unable to create target"
  touch "${first_dependency_path}/dependencies" || fail "Unable to create dependencies"

  local -r second_dependency_path="${temp_directory_path}/dependencies/bar"
  mkdir -p "${second_dependency_path}" || fail "Unable to create dependency directory: ${second_dependency_path}"
  touch "${second_dependency_path}/install.sh" || fail "Unable to create installation script"
  chmod 555 "${second_dependency_path}/install.sh" || fail "Unable to create installation script"
  touch "${second_dependency_path}/source" || fail "Unable to create source"
  touch "${second_dependency_path}/target" || fail "Unable to create target"
  touch "${second_dependency_path}/dependencies" || fail "Unable to create dependencies"

  assert 0 "" install_dependencies "${temp_directory_path}"
}

main
