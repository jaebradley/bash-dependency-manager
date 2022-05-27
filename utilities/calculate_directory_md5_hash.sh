#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/filesystem/directories/validate_directory.sh"
. "$(dirname "${BASH_SOURCE}")/filesystem/directories/calculate_file_contents_md5_hash.sh"
. "$(dirname "${BASH_SOURCE}")/filesystem/directories/calculate_directory_name_md5_hash.sh"
. "$(dirname "${BASH_SOURCE}")/filesystem/directories/calculate_file_names_md5_hash.sh"

# Only calculates the md5 hash of directories that consist of only 1 level of regular files
function calculate_directory_md5_hash() {
  if [[ "1" != "$#" ]]; then echo "Expected a single argument representing the path to a directory" && return 255; fi

  local directory_path

  directory_path=$(validate_directory "$1")
  if [[ "0" != "$?" ]]; then echo "Unable to validate directory" && return 255; fi

  local directory_name_hash
  directory_name_hash=$(calculate_directory_name_md5_hash "${directory_path}")
  if [[ "0" != "$?" ]]; then echo "Unable to calculate directory name" && return 255; fi

  pushd "${directory_path}" > /dev/null
  if [[ "0" != "$?" ]]; then echo "Unable to switch directories" && return 255; fi

  local file_contents_hash
  file_contents_hash=$(calculate_directory_file_contents_md5_hash ".")
  if [[ "0" != "$?" ]]; then echo "Unable to calculate file contents hash" && return 255; fi

  local filenames_hash
  filenames_hash=$(calculate_file_names_md5_hash ".")
  if [[ "0" != "$?" ]]; then echo "Unable to calculate filenames hash" && return 255; fi

  popd > /dev/null
  if [[ "0" != "$?" ]]; then echo "Unable to switch to original directory" && return 255; fi

  md5 -q -s "${directory_hash}${filenames_hash}${file_contents_hash}"
}
