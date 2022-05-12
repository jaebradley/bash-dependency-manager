#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/utilities/filesystem/directories/identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order.sh"
. "$(dirname "${BASH_SOURCE}")/install_dependency.sh"

function install_dependencies() {
  if [[ "1" != "$#" ]]
  then
    fail "Expected a single argument"
  fi

  local installation_directory="$1"

  local dependencies_directory="${installation_directory}/dependencies"
  local cache_directory="${installation_directory}/.cache"

  mkdir -p "${dependencies_directory}" || fail "Unable to create dependencies directory"
  mkdir -p "${cache_directory}" || fail "Unable to create cache directory"

  while IFS='' read -r -d '' dependency_path
  do
    install_dependency "${dependency_path}" "${cache_directory}" || fail "Unable to install dependency: ${dependency_path}"
  done < <(identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "${dependencies_directory}")
}

