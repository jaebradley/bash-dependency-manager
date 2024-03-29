#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../utilities/fail.sh" || (echo "Unable to install dependency on line ${LINENO}" && exit 255)
. "$(dirname "${BASH_SOURCE}")/../utilities/filesystem/directories/identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order.sh" || fail "Unable to install dependency on line ${LINENO}"
. "$(dirname "${BASH_SOURCE}")/install_dependency.sh"|| fail "Unable to install dependency on line ${LINENO}"

install_dependencies() {
  if [[ "1" != "$#" ]]; then fail "Expected a single argument representing the directory path to install dependencies in"; fi

  local -r installation_directory_path="$1"
  if [[ "${installation_directory_path}" =~ ^\. ]]; then fail "Absolute installation directory must be specified: ${installation_directory_path}"; fi

  local -r dependencies_directory_path="${installation_directory_path}/dependencies"
  mkdir -p "${dependencies_directory_path}" || fail "Unable to create dependencies directory"

  local -r cache_directory_path="${dependencies_directory_path}/.cache"
  mkdir -p "${cache_directory_path}" || fail "Unable to create cache directory"

  while IFS='' read -r -d '' dependency_path
  do
    echo "Starting to install dependency: ${dependency_path}" || fail "Error on ${LINENO}"
    install_dependency "${dependency_path}" "${cache_directory_path}" || fail "Unable to install dependency: ${dependency_path}";
    echo "Successfully installed dependency: ${dependency_path}" || fail "Error on ${LINENO}"
  done < <(identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "${dependencies_directory_path}")
}
