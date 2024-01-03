BASE_URL="https://raw.githubusercontent.com/david-luna/shell-aliases/main/"

# Create folder
if [ -d "~/.sh_tools" ]; then
  # TODO: maybe cleanup folder?
  echo "Updating SH tools"
else
  echo "Installing SH tools"
  mkdir ~/.sh_tools
  mkdir ~/.sh_tools/envs
fi

# Copy sources
#curl -o ~/.sh_tools/colors.sh "${BASE_URL}colors.sh"
echo "${BASE_URL}colors.sh"

# Add to rc/profile files
