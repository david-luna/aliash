#!/bin/bash

# Got these nice ideas from
# https://www.youtube.com/watch?v=mSXOYhfDFYo

INSTALL_URL="https://raw.githubusercontent.com/david-luna/aliash/main"
INSTALL_PATH=$(realpath ".")
REQUIRED=("colors")
OPTIONAL=("git-cli" "with-env")

function confirm() {
  read -p "$1 (Y/n):" response
  [ -z "$response" ] || [ "$response" = "y" ]
}

function addSource() {
  url = "${INSTALL_URL}/sources/$1.sh"
  echo "Downloading ${url}"
  echo "\n\n file: ${url}\n"
  curl "${INSTALL_URL}/sources/$1.sh" >> "${INSTALL_PATH}/alia.sh"
}


if confirm "Install in ${INSTALL_PATH}?"; then
  echo "Installing"
  # add REQUIRED files
  for file in "${REQUIRED[@]}"
  do
    addSource "$file"
  done
  
  # ask for the OPTIONAL
  for file in "${OPTIONAL[@]}"
  do
    if confirm "Source ${file}?"; then
      addSource "$file"
    fi
  done

  # source file to .zshrc or echo a message
  if [ -f "${HOME}/.zshrc" ]; then
    echo "\nsource ${INSTALL_PATH}/alia.sh" >> "${HOME}/.zshrc"
  fi

else
  echo "Please create a folder and CD into it for installation"
fi
