#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../installation/install_dependencies.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/filesystem/directories/create_temporary_directory.sh"
. "$(dirname "${BASH_SOURCE}")/../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../utilities/assert.sh"

main() {
  local temp_directory_path
  temp_directory_path=$(create_temporary_directory)
  if [[ "0" != "$?" ]]; then fail "Unable to create temporary directory"; fi

  local -r first_dependency_path="${temp_directory_path}/dependencies/foo"
  mkdir -p "${first_dependency_path}" || fail "Unable to create dependency directory: ${first_dependency_path}"
  touch "${first_dependency_path}/install.sh" || fail "Unable to create installation script"
  chmod 755 "${first_dependency_path}/install.sh" || fail "Unable to create installation script"
  echo -ne "#!/bin/sh\nexit 255" > "${first_dependency_path}/install.sh" || fail "Unable to overwrite installation script"
  touch "${first_dependency_path}/source" || fail "Unable to create source"
  touch "${first_dependency_path}/target" || fail "Unable to create target"
  touch "${first_dependency_path}/dependencies" || fail "Unable to create dependencies"

  assert 255 "Starting to install dependency: ${first_dependency_path}
Unable to install foo at ${first_dependency_path} with output: 
Unable to install dependency: ${first_dependency_path}" install_dependencies "${temp_directory_path}"
}

main

