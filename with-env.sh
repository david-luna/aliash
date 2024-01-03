#!/usr/bin/env bash

# Colors
source ~/.zsh_tools/colors.sh

# Use it to have default cloud environment for APM
# Add environment files into a script
# $1 name of the environment file we need to load
function withEnv() {
  local envs_list=$(ls ~/.envs)
  if [ $# -lt 2 ]; then
    echo -e "${Red}Error:: You must provide at least an environment and a command.${Color_Off}";
    echo -e "${Blue}Available envs::\n${Green}$envs_list${Color_Off}";
    return
  fi

  local env_file="$HOME/.envs/$1"
  if [ ! -e "$env_file" ]; then
    echo -e "${Red}Error:: There is no environment named ${Yellow}$1${Red}.${Color_Off}";
    return
  fi

  local content=$(grep -v "^#" "$env_file")
  local options=$(echo $content | tr '\n' ' ')
  local pattern=" |'"
  local command="$options"

  # pop out the environment param & iterate over the rest of the command
  shift
  for param in "$@"
  do
    if [[ "$param" =~ $pattern ]]
    then
      command="$command \"$param\""
    else
      command="$command $param"
    fi
  done

  eval $command
}

# Usage: wenv apm node ./examples/trace-http.js
alias wenv='function f() { withEnv "$@"; }; f';