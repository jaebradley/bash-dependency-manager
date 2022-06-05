#!/bin/bash/

validate_darwin() {
  if [[ "0" != "$#" ]]; then echo "Expected no arguments" && return 255; fi

  local operating_system_name
  operating_system_name=$(uname -s)
  if [[ "Darwin" == "${operating_system_name}" ]]
  then
    return 0
  else
    return 255
  fi
}
