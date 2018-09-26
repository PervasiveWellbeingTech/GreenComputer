#!/bin/bash

if [[ ! -z "$1" && "$1" -ge 700 && "$1" -le 6500 ]]; then
  defaults write org.herf.Flux dayColorTemp -int "$1"
  #killall Flux
  #open /Users/peterwashington/Applications/Flux.app
else
  echo "provide a temperature between 2700 and 6500 (rounded to nearest 100)"
fi