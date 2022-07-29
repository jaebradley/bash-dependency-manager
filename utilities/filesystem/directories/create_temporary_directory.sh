#!/bin/bash

. "$(dirname ${BASH_SOURCE})/../../fail.sh"

function create_temporary_directory() {
  local id
  id=$(uuidgen)
  if [[ "0" != "$?" ]]; then fail "Unable to generate UUID on line ${LINENO}"; fi

  local -r path="/tmp/${id}"
  mkdir -p "${path}" || fail "Error on ${LINENO}"
  printf "${path}" || fail "Error on ${LINENO}"
}
