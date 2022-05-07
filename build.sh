#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/utilities/filesystem/directories/identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order.sh"
. "$(dirname "${BASH_SOURCE}")/utilities/calculate_directory_md5_hash.sh"

DEPENDENCIES_DIRECTORY_NAME="dependencies"
CACHE_DIRECTORY_NAME=".cache"

function install_dependency() {
  if [[ "2" != "$#" ]]
  then
    fail "Expected a single argument"
  fi

  local -r dependency_path="$1"
  local -r cache_path="$2"

  local -r dependency_name=$(basename "${dependency_path}")
  local -r md5_hash_of_dependency=$(calculate_directory_md5_hash "${dependency_path}")
  local -r cache_installation_record="${cache_path}/${md5_hash_of_dependency}" 
  if [[ -e "${cache_installation_record}" ]]
  then
    echo "${dependency_name} has already been installed"
  else
    while IFS='' read -r dependency_directory_path; do
      install_dependency "${dependency_directory_path}"
    done < "${dependency_path}/dependencies"

    local -r target=$(cat "${dependency_path}/target")
    local -r source=$(cat "${dependency_path}/source")
    local -r installation_script="${dependency_path}/install.sh"

    if [[ -x "${installation_script}" ]];
    then
      . "${installation_script}" "${source}" "${target}" || fail "Unable to install ${dependency_name}"
    else
      fail "Installation script "${installation_script}" is not executable"
    fi

    touch "${cache_installation_record}" || fail "Unable to create file ${cache_installation_record}"
  fi
}

function install_dependencies() {
  if [[ "1" != "$#" ]]
  then
    fail "Expected a single argument"
  fi

  local installation_directory="$1"

  local dependencies_directory="${installation_directory}/${DEPENDENCIES_DIRECTORY_NAME}"
  local cache_directory="${installation_directory}/${CACHE_DIRECTORY_NAME}"

  mkdir -p "${dependencies_directory}" || fail "Unable to create dependencies directory"
  mkdir -p "${cache_directory}" || fail "Unable to create cache directory"

  while IFS='' read -r -d '' dependency_path
  do
    install_dependency "${dependency_path}" "${cache_directory}" || fail "Unable to install dependency: ${dependency_path}"
  done < <(identify_nonhidden_direct_subdirectories_in_alphabetically_ascending_order "${dependencies_directory}")
}
