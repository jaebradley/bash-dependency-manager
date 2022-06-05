#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../installation/install_dependencies.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh"

create_independent_dependency() {
  if [[ "1" != "$#" ]]; then fail "Expected a single argument representing the dependency path"; fi

  local -r dependency_directory_path="$@"
  mkdir -p "${dependency_directory_path}" || fail "Unable to create directory at ${dependency_directory_path}"

  local -r dependency_installation_script_path="${dependency_directory_path}/install.sh"
  touch  "${dependency_installation_script_path}" || fail "Unable to create installation script file"
  chmod 500 "${dependency_installation_script_path}" || fail "Unable to make installation script ${dependency_installation_script_path} writable"

  touch "${dependency_directory_path}/target" || fail "Unable to create target file"
  touch "${dependency_directory_path}/source" || fail "Unable to create source file"
  touch "${dependency_directory_path}/dependencies" || fail "Unable to create dependencies file"
}

main() {
  assert 255 "Expected a single argument representing the directory path to install dependencies in" install_dependencies
  assert 255 "Expected a single argument representing the directory path to install dependencies in" install_dependencies "foo" "bar"

  local temp_directory
  temp_directory=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  local -r temp_dependencies_directory_path="${temp_directory}/dependencies"
  mkdir -p "${temp_dependencies_directory_path}" || fail "Unable to create directory at ${temp_dependencies_directory_path}"

  local -r cache_dependencies_path="${temp_directory}/.cache"
  mkdir -p "${cache_dependencies_path}" || fail "Unable to create directory at ${cache_dependencies_path}"

  local first_dependency_path
  first_dependency_path=$(create_independent_dependency "${temp_dependencies_directory_path}/foo")
  if [[ "0" != "$?" ]]; then fail "Could not create first dependency"; fi

  local second_dependency_path
  second_dependency_path=$(create_independent_dependency "${temp_dependencies_directory_path}/foo")
  if [[ "0" != "$?" ]]; then fail "Could not create second dependency"; fi

  assert 0 "" install_dependencies "${temp_directory}"
}

main

