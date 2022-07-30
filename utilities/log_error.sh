#!/bin/bash

log_error() {
  if [[ $# -gt 1 ]]; then printf "Expected exactly zero arguments or one argument, a message\n" && return 255; fi
  if [[ "1" == "$#" ]]
  then 
    local -r message="$1\n"
    printf "${message}" >&2
    printf "${message}"
  fi
}

