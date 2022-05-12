#!/bin/bash


. "$(dirname "${BASH_SOURCE}")/fail.sh"

# Only calculates the md5 hash of directories that consist of only regular files

function calculate_directory_md5_hash() {
  if [[ "1" != "$#" ]]
  then
    echo "Expected a single argument"
    return 255
  fi

  local -r directory_path="$1"

  if [[ ! -e "${directory_path}" ]]
  then
    echo "${directory_path} does not exist"
    return 255
  fi
  if [[ ! -d "${directory_path}" ]]
  then 
    echo "${directory_path} is not a directory"
    return 255
  fi

  local return_code

  local directory_name
  directory_name=$(basename "${directory_path}")
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    echo "Unable to calculate filename hashes"
    return 255
  fi

  local directory_hash
  directory_hash=$(md5 -q -s "${directory_name}")
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    echo "Unable to calculate filename hashes"
    return 255
  fi

  set -o pipefail

  pushd "${directory_path}" > /dev/null
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    set +o pipefail
    echo "Unable to switch directories"
    return 255
  fi

  local filenames_hash
  filenames_hash=$(find . -type f -maxdepth 1 -mindepth 1 -print0 | sort --zero-terminated | md5 -q)
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    set +o pipefail
    echo "Unable to calculate filenames hash"
    return 255
  fi

  local file_contents_hash
  file_contents_hash=$(find . -type f -maxdepth 1 -mindepth 1 -print0 | sort --zero-terminated | xargs -0 md5 -q | md5 -q)
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    set +o pipefail
    echo "Unable to calculate file contents hash"
    return 255
  fi

  popd > /dev/null
  return_code="$?"
  if [[ "0" != "${return_code}" ]]
  then
    set +o pipefail
    echo "Unable to switch to original directory"
    return 255
  fi

  set +o pipefail

  md5 -q -s "${directory_hash}${filenames_hash}${file_contents_hash}"
}
