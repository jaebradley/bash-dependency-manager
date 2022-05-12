#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/utilities/calculate_directory_md5_hash.sh"

function install_dependency() {
  [[ "2" == "$#" ]] || fail "Expected a single argument"

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

    if [[ -x "${installation_script}" ]]
    then
      . "${installation_script}" "${source}" "${target}" || fail "Unable to install ${dependency_name}"
    else
      fail "Installation script "${installation_script}" is not executable"
    fi

    touch "${cache_installation_record}" || fail "Unable to create file ${cache_installation_record}"
  fi
}
