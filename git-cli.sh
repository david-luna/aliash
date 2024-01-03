#!/usr/bin/env bash

# Colors
source ~/.zsh_tools/colors.sh

# gets sublist of branches
# $1 text contained in the branch name
function branches() {
  local filter=$1;
  local branches=$(eval 'git branch -a | grep $filter | sed -e "s/^[ \x09\*]*//"')

  echo "$branches";
}

# Filters stdin of branches to show only the remote ones
function remotes() {
  grep -E '^remotes/origin'
}

# Filters stdin of branches to show only the local ones
function locals() {
  grep -Ev '^remotes/origin'
}


# Removes the 1st branch listed that contains the search term (asks for confirmation)
# $1 search_term partial name of the branch
# $2 remote vaue "r" if we have to eliminate the remote
function gitDelete() {
  local current=$(git rev-parse --abbrev-ref HEAD)
  local type=$([ "$2" = "r" ] && echo "remote" || echo "local")
  local branch=$(branches $1 | ([ "$type" = "remote" ] && remotes || locals) | head -1)

  if [ "$branch" = "" ]; then
    echo -e "${Red}Error:: Cannot find a branch with the search term ${Blue}\"$1\"${Red}. Use a better search term${Color_Off}";
    return;
  fi
  if [ "$branch" = "$current" ]; then
    echo -e "${Red}Error:: Cannot remove current branch. Use a better search term${Color_Off}";
    return;
  fi

  # Make sure we have the proper ref
  branch="${branch/remotes\/origin\//}"

  echo -e "${Yellow}remove $type branch: ${Blue}$branch ${Yellow}? (y/n)${Color_Off}"
  read PROMPT_RESP
  if [ "$PROMPT_RESP" = "y" ]; then
    echo -e "${Green}Deleting branch ${Blue}$branch${Green}${Color_Off}"
    [ "$type" = "local" ] && git branch -D $branch || git push -d origin $branch;
    echo -e "${Green}Done: $type branch ${Blue}$branch ${Green}deleted!${Color_Off}"
  fi
}

# Checkout the 1st branch listed that contains the search term
# $1 search_term partial name of the branch
# $1 pull if "p" pull changes from origin
function gitCheckout() {
  git fetch;
  branches $1 -a | head -1 | sed -e "s/^.*origin\///" | xargs git checkout;
  if [ "$2" = "p" ]; then
    git pull;
  fi
}

# Create a new local branch with the name passed
# if branch already exists it switches to it
# $1 name the name of the branch
function gitBranch() {
  if [ "$1" = "" ]; then
    git branch;
    return
  fi

  local branch=$(branches $1 | head -n 1)

  if [ "$branch" = "" ]; then
    echo -e "${Yellow}Creating branch ${Blue}$branch ${Yellow}... ${Color_Off}"
    git checkout -b $1;
  else
  echo -e "${Yellow}Branch ${Blue}$branch ${Yellow}already exists. Doing checkout instead ${Color_Off}"
    gitCheckout $1;
  fi
}

# Runc git pull on all subdirs that contain a repo
function gitPullAll() {
  find . -name .git -type d -execdir git pull -v ';'
}


# To try things here
function gitTest() {
  
}

# push with lint before
alias g-push='function f() { if [ -f "package.json" ]; then yarn lint; fi git push; }; f';
#add
alias g-add='function f() { git status | grep $1 | sed -e "s/^.*libs/libs/g" | xargs git add; git status }; f';
#clean-tags
alias g-tag-clean='function f() { git tag -l | xargs git tag -d && git fetch -t }; f';
#squash
alias g-sq='function f() { git rebase -i HEAD~$1; }; f';


# New aliases
# checkout
alias gco='function f() { gitCheckout $1 $2; }; f';
# branch (with fallback to checkout)
alias gbr='function f() { gitBranch $1; }; f';
# delete (remote via param)
alias gdel='function f() { gitDelete $1 $2; }; f';
# pull all
alias gpall='function f() { gitPullAll; }; f';

alias gtest='function f() { gitTest $1 $2; }; f';