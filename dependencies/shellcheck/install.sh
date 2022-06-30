#! /bin/bash

. "$(dirname "${BASH_SOURCE}")/../../utilities/fail.sh";
. "$(dirname "${BASH_SOURCE}")/../../utilities/filesystem/directories/create_temporary_directory.sh";

install() {
  if [[ "3" != "$#" ]]; then fail "Expected three arguments: a source binary URL, a target destination, and the dependency path"; fi

  local -r source="$1"
  local -r relative_target_path="$2"
  local -r dependency_path="$3"
  local -r target="${dependency_path}/${relative_target_path}"
  
  mkdir -p "${target}" || fail "Could not create target ${target}"

  if [[ ! -w "${target}" ]]; then fail "Cannot write to ${target}"; fi

  local temporary_directory_path
  temporary_directory_path=$(create_temporary_directory)

  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  pushd "${temporary_directory_path}" > /dev/null || fail "Unable to change directories to ${temporary_directory_path}"

  local -r source_file_name="_"

  curl "${source}" -L --output "${source_file_name}" -s || fail "Unable to download ${source}"
  tar -xvzf "${source_file_name}" || fail "Unable to extract shellcheck binary"

  local -r shellcheck_executable_directory_path="${temporary_directory_path}/shellcheck-v0.8.0"
  if [[ ! -x "${shellcheck_executable_directory_path}" ]]; then fail "Expected extracted shellcheck executable directory does not exist in directory ${temporary_directory_path}"; fi

  mv "${shellcheck_executable_directory_path}" "${target}" || fail "Unable to move shellcheck executable directory from ${shellcheck_executable_directory_path} to ${target}"

  popd "${temporary_directory_path}" > /dev/null || fail "Unable to change directories from ${temporary_directory_path}"
}

install "$@"
