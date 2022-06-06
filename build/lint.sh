#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../utilities/fail.sh"

# TODO: @jaebradley currently only linting top-level install.sh
# Support linting other bash files one directory at a time
lint() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments, the path to the shellcheck executable, and the top-level directory path"; fi
  local -r shellcheck_executable_path="$1"
  local -r project_directory_path="$2"

  local current_directory_path
  current_directory_path=$(dirname "${BASH_SOURCE[0]}")
  if [[ ! $? ]]; then fail "Unable to calculate current directory"; fi

  if [[ ! -x "${shellcheck_executable_path}" ]]; then fail "Unable to execute shellcheck executable at path: ${shellcheck_executable_path}"; fi
  if [[ ! -d "${project_directory_path}" ]]; then fail "Project directory path at ${project_directory_path} is not a directory"; fi

  # TODO: @jaebradley sort these files
  for file in $(find "${project_directory_path}" -mindepth 1 -maxdepth 1 -name "*.sh" -type f)
  do
    echo "Shellcheck for ${file}"
    "${shellcheck_executable_path}" "${file}"
    if [[ ! $? ]]; then fail "Shellcheck failed for ${file}"; fi
  done
}
