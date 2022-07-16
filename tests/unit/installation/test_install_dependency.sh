#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../installation/install_dependency.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh"

main() {
  assert 255 "Expected two arguments: a path to the dependency and a path to the cache directory" install_dependency
  assert 255 "Expected two arguments: a path to the dependency and a path to the cache directory" install_dependency "foo"
  assert 255 "Expected two arguments: a path to the dependency and a path to the cache directory" install_dependency "foo" "bar" "baz"

  local temp_directory
  temp_directory=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  local -r temp_dependencies_directory_path="${temp_directory}/dependencies"
  mkdir -p "${temp_dependencies_directory_path}" || fail "Unable to create directory at ${temp_dependencies_directory_path}"

  local -r cache_dependencies_path="${temp_directory}/cache"
  mkdir -p "${cache_dependencies_path}" || fail "Unable to create directory at ${cache_dependencies_path}"

  local -r dependency_directory_path="${temp_dependencies_directory_path}/foo"
  mkdir -p "${dependency_directory_path}" || fail "Unable to create directory at ${dependency_directory_path}"


  local -r dependency_installation_script_path="${dependency_directory_path}/install.sh"
  assert 255 "Installation script ${dependency_installation_script_path} is not a regular file" install_dependency "${dependency_directory_path}" "${cache_dependencies_path}"
  touch  "${dependency_installation_script_path}" || fail "Unable to create installation script file"
  chmod 500 "${dependency_installation_script_path}" || fail "Unable to make installation script ${dependency_installation_script_path} writable"

  assert 255 "Failed to read contents of target location file for dependency at ${dependency_directory_path}" install_dependency "${dependency_directory_path}" "${cache_dependencies_path}"
  touch "${dependency_directory_path}/target" || fail "Unable to create target file"

  assert 255 "Failed to read contents of source location file for dependency at ${dependency_directory_path}" install_dependency "${dependency_directory_path}" "${cache_dependencies_path}"
  touch "${dependency_directory_path}/source" || fail "Unable to create source file"

  assert 255 "Dependencies path at ${dependency_directory_path}/dependencies is not a regular file" install_dependency "${dependency_directory_path}" "${cache_dependencies_path}"
  touch "${dependency_directory_path}/dependencies" || fail "Unable to create dependencies file"

  assert 0 "Successfully installed foo at ${dependency_directory_path} with output: " install_dependency "${dependency_directory_path}" "${cache_dependencies_path}"
  assert 0 "foo has already been installed" install_dependency "${dependency_directory_path}" "${cache_dependencies_path}"
}

main
