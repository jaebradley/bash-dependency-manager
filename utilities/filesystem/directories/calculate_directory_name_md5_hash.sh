#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/validate_directory.sh"

function calculate_directory_name_md5_hash() {
  (set +o pipefail && validate_directory "$@" | xargs basename | xargs md5 -q)

