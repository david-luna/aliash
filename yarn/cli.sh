# checkout based on brach substring
alias y-switch='function f() { if [ -f "${HOME}/.yarnrc_$1" ]; then cp -f "${HOME}/.yarnrc_$1" "${HOME}/.yarnrc"; echo "changed yarnrc to $1 environment"; fi }; f';
