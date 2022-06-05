#! /bin/bash

. "$(dirname "${BASH_SOURCE}")/../../utilities/fail.sh";
. "$(dirname "${BASH_SOURCE}")/../../utilities/create_temporary_directory.sh";

install() {
  if [[ "2" != "$#" ]]; then fail "Expected two arguments: a source and target destination"; fi

  local -r source="$1"
  local -r target="$2"

  local temporary_directory_path
  temporary_directory_path=$(create_temporary_directory)

  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  pushd "${temporary_directory_path}" > /dev/null || fail "Unable to change directories to ${temporary_directory_path}"

  tar -xvzf "${source}" || fail "Unable to extract shellcheck binary"

  local -r shellcheck_executable_path="${temporary_directory_path}/shellcheck-stable"
  if [[ ! -x "${shellcheck_executable_path}" ]]; then fail "Expected extracted shellcheck executable does not exist"; fi

  mv "${shellcheck_executable_path}" "${target}" || fail "Unable to move shellcheck executable from ${shellcheck_executable_path} to ${target}"

  popd "${temporary_directory_path}" > /dev/null || fail "Unable to change directories from ${temporary_directory_path}"
}

install "$@"
