#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/../utilities/calculate_directory_md5_hash.sh"

install_dependency() {
  if [[ "2" != "$#" ]]; then echo "Expected two arguments: a path to the dependency and a path to the cache directory" && return 255; fi

  local -r dependency_path="$1"
  local -r cache_directory_path="$2"

  local md5_hash_of_dependency
  md5_hash_of_dependency=$(calculate_directory_md5_hash "${dependency_path}")
  if [[ "0" != "$?" ]]; then echo "Unable to calculate md5 hash for dependency at ${dependency_path}" && return 255; fi

  local dependency_name
  dependency_name=$(basename "${dependency_path}")
  if [[ "0" != "$?" ]]; then echo "Unable to calculate basename for dependency at ${dependency_path}" && return 255; fi

  local -r cache_installation_record_path="${cache_directory_path}/${md5_hash_of_dependency}" 
  if [[ -e "${cache_installation_record_path}" ]]
  then
    echo "${dependency_name} has already been installed"
  else
    local -r installation_script="${dependency_path}/install.sh"
    if [[ ! -f "${installation_script}" ]]; then echo "Installation script ${installation_script} is not a regular file" && return 255; fi
    if [[ -x "${installation_script}" ]]
    then
      local target
      target=$(cat "${dependency_path}/target" 2>/dev/null)
      if [[ "0" != "$?" ]]; then echo "Failed to read contents of target location file for dependency at ${dependency_path}" && return 255; fi

      local source
      source=$(cat "${dependency_path}/source" 2>/dev/null)
      if [[ "0" != "$?" ]]; then echo "Failed to read contents of source location file for dependency at ${dependency_path}" && return 255; fi

      local -r dependencies_path="${dependency_path}/dependencies"
      if [[ ! -f "${dependencies_path}" ]]; then echo "Dependencies path at ${dependencies_path} is not a regular file" && return 255; fi
      if [[ ! -r "${dependencies_path}" ]]; then echo "Dependencies path at ${dependencies_path} is not readable" && return 255; fi
      # TODO: order dependencies alphabetically
      while IFS='' read -r parent_dependency_path
      do
        $(install_dependency "${parent_dependency_path}" "${cache_directory_path}")
        if [[ "0" != "$?" ]]; then echo "Unable to install ${parent_dependency_path} dependency for dependency at ${dependency_path}" && return 255; fi
      done < "${dependencies_path}"

      local installation_output
      installation_output=$(source "${installation_script}" "${source}" "${target}" "${dependency_path}")
      if [[ "0" != "$?" ]];
        then echo "Unable to install ${dependency_name} at ${dependency_path} with output: ${installation_output}" && return 255;
        else echo "Successfully installed ${dependency_name} at ${dependency_path} with output: ${installation_output}";
      fi
    else
      echo "Installation script "${installation_script}" is not executable" && return 255
    fi

    touch "${cache_installation_record_path}"
    if [[ "0" != "$?" ]]; then echo "Unable to create cache installation record at ${cache_installation_record_path} for dependency: ${dependency_path}" && return 255; fi
  fi
}
