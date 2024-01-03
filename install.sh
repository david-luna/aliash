if [ -d "~/.zsh_tools" ]; then
  # TODO: maybe cleanup folder?
  echo "Updating ZSH tools"
else
  echo "Installing ZSH tools"
  mkdir ~/.zsh_tools
  mkdir ~/.zsh_tools/envs
fi

cp ./git/cli.sh ~/.zsh_tools/git/cli.sh
