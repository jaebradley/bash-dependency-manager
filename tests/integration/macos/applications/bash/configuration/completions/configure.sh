#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../../../../utilities/fail.sh"
. "$(dirname "${BASH_SOURCE}")/../../../../utilities/filesystem/directories/create_temporary_directory.sh"

location_path="$HOME/.bash/completions.sh"

directory_path="$(dirname "${location_path}")"
file_name="$(basename "${location_path}")"

mkdir -p "${directory_path}" || fail "Failed to create directory ${directory_path}"

tmp_directory="$(create_temporary_directory)"
target="${tmp_directory}/_.xz"
url="https://github.com/scop/bash-completion/releases/download/2.11/bash-completion-2.11.tar.xz"

curl -fL -o "${target}" "${url}" || fail "Failed to output bash completions to ${target}"
tar -xzf "${target}" -C "${tmp_directory}" || fail "Failed to extract completions at ${target}"
pushd "${tmp_directory}/bash-completion-2.11"

./configure
make

user_id="$(id -u)"
if [[ "${user_id}" -eq 0 ]]
then
  sudo make install
else
  read -r -s password
  sudo -S "${password}" make install
  su - "${user_id}"
fi

popd
