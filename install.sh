#!/usr/bin/env bash

BASE_PATH="~/.sh_tools"
BASE_URL="https://raw.githubusercontent.com/david-luna/shell-aliases/main/"

# Create folder

if [ ! -d "$BASE_PATH" ]; then
  echo "Installing SH tools"
  mkdir ~/.sh_tools
  mkdir ~/.sh_tools/envs
fi

# Copy sources to a single file
rm -f ~/.sh_tools/aliases.sh
echo "#!/usr/bin/env bash" >> ~/.sh_tools/aliases.sh

files=("colors" "git-cli" "with-env")
for f in "${files[@]}"
do
  echo "Downloading ${BASE_URL}${f}.sh"
  curl "${BASE_URL}${f}.sh" >> ~/.sh_tools/aliases.sh
done

# TODO: Add to rc/profile files
