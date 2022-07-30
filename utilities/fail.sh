#!/bin/bash

function fail() {
  if [[ $# -gt 1 ]]; then printf "Expected exactly zero arguments or one argument, a message\n" && exit 255; fi
  if [[ "1" == "$#" ]]; then printf "$1\n"; fi
  exit 255
}
