#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../utilities/fail.sh";

execute_test_file() {
    if [[ "1" != "$#" ]]; then fail "Expected a single path to file argument"; fi

    local -r file_path="$1";

    if [[ ! -f "${file_path}" ]]; then fail "File ${file_path} is not a regular file"; fi
    if [[ ! -x "${file_path}" ]]; then fail "File ${file_path} is not executable"; fi

    local file_name
    file_name=$(basename "${file_path}")
    if [[ "0" != "$?" ]]; then fail "Unable to calculate file name for ${file_path}"; fi

    echo "----- Starting ${file_name} -----"
    echo "File is at path: ${file_path}"
    time "${file_path}"
    local -r exit_code="$?"
    echo "----- Finished ${file_name} with exit code: ${exit_code} -----"
    if [[ "0" != "${exit_code}" ]]; then fail "Tests failed"; fi
}
