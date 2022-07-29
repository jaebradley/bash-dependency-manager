#!/bin/bash

function fail() {
  if [[ "$1" != "" ]]; then printf "$1\n"; fi
  exit 255
}
