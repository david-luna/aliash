# helper function
function dynamicSelect () {
  local command=$1;
  local result=$(eval "$command");

  # TODO
  # transform to array
  #options=($result);
  read -a options <<< $result

  #echo "options are $options";
  select option in "${options[@]}"; do
    echo "You have chosen $option"
    [[ $option == exit ]] && break
  done

}

# gets sublist of branches
# $1 target variable name
# $2 delimiter
# $2 input string
split() {
  IFS=$2 read -a "$1" -r -d '' < <(printf %s "$3")
}

# gets sublist of branches
# $1 text containde in the branch name
# $2 flag for all(remote) branches (value -a)
function branches() {
  local filter=$1;
  local all=$2;
  local branches=$(eval 'git branch $all | grep $filter | sed -e "s/^[ \x09\*]*//" | sed -e "s/^.*origin\///"')
  echo "$branches";
}

gitTest() {
  local list=$(eval "branches a -a");
  split options "\n" "$list";
  $ printf -- "--%s\n" "${options[@]}"
}

# gets sublist of branches
# $1 the branch to remove
gitRemoteDelete() {
  echo -e "${Yellow}remove branch: $1 ? (y/n)${Color_Off}"
  read PROMPT_RESP
  if [ "$PROMPT_RESP" == "y" ]; then
    echo -e "removed"
  fi
}


# checkout based on brach substring
alias g-co='function f() { git fetch; git branch -a | grep $1 | sed -e "s/^.*origin\///" | head -1 | xargs git checkout; if [ $1 = "master" ]; then git pull; fi }; f';
# create a local branch
alias g-br='function f() { git checkout -b $1; }; f';
# push with lint before
alias g-push='function f() { if [ -f "package.json" ]; then yarn lint; fi git push; }; f';
# delete local/forced/remote
alias g-del='function f() { git branch -a | grep $1 | head -1 | xargs git branch -d }; f';
alias g-delf='function f() { git branch -a | grep $1 | head -1 | xargs git branch -D }; f';
# alias g-delr='function f() { git branch -a | grep "remotes/origin" | grep $1 | | sed -e "s/^.*origin\///" | head -1 | xargs git push -d origin }; f';
alias g-delr='function f() { git branch -a | grep "remotes/origin" | grep $1 | sed -e "s/^.*origin\///" | head -1 | xargs echo "git push -d origin" }; f';
#add
alias g-add='function f() { git status | grep $1 | sed -e "s/^.*libs/libs/g" | xargs git add; git status }; f';
#clean-tags
alias g-tag-clean='function f() { git tag -l | xargs git tag -d && git fetch -t }; f';
#squash
alias g-sq='function f() { git rebase -i HEAD~$1; }; f';
