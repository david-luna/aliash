#!/bin/bash

# Got these nice ideas from
# https://www.youtube.com/watch?v=mSXOYhfDFYo

INSTALL_URL="https://raw.githubusercontent.com/david-luna/aliash/main"
INSTALL_PATH=$(realpath ".")
INSTALL_FILE="${INSTALL_PATH}/alia.sh"
REQUIRED=("colors")
OPTIONAL=("git-cli" "with-env")

function confirm() {
  read -p "$1 (Y/n):" response
  [ -z "$response" ] || [ "$response" = "y" ]
}

function addSource() {
  local url="${INSTALL_URL}/sources/$1.sh"

  echo "Downloading $url"
  echo -e "\n\n# file: $url\n" >> $INSTALL_FILE
  curl "${INSTALL_URL}/sources/$1.sh" >> $INSTALL_FILE
}


if confirm "Install in ${INSTALL_PATH}?"; then
  echo "Installing"
  # cleanup any prev installation
  rm $INSTALL_FILE;

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
  target="${HOME}/.zshrc"
  if [ -f "$target" ]; then
    echo -e "\nsource ${INSTALL_FILE}" >> "$target"
  else
    echo "Could not add aliases into $target"
    echo "You can add the aliases manually by adding the following line into your .rc file"
    echo "  source ${INSTALL_FILE}/alia.sh"
  fi

else
  echo "Please create a folder and CD into it for installation"
fi
