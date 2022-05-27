#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../utilities/fail.sh";

execute_test_file() {
    if [[ "1" != "$#" ]]; then fail "Expected a single path to file argument"; fi

    local -r file_path="$1";

    if [[ ! -e "${file_path}" ]]; then fail "File path ${file_path} does not exist"; fi
    if [[ ! -f "${file_path}" ]]; then fail "File ${file_path} is not a regular file"; fi
    if [[ ! -x "${file_path}" ]]; then fail "File ${file_path} is not executable"; fi

    echo "Starting to execute: ${file_path}"
    time . "${file_path}"
    echo "Finished with exit code: $?"
}