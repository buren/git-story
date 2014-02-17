###########
#  dev   #
###########

__gs-dev-help() {
  __gs-print "
description:
\t start implenting your feature.
usage:
\t gs dev <branch_name> <base_branch>
<base_branch> is optional and will fall back to master

Guarantees clean workspace from remote master (or specified branch).

If --force is supplied as the second argument no checks will be made."
}

__gs-dev() {
  if [[ -z "$1" ]]; then
    __gs-dev-help
    __gs-error "You must provide a branch name"
    __gs-error "Missing argument <branch_name>"
    return
  elif [[ $1 == "--help" ]]; then
    __gs-dev-help
    return
  elif [[ $2 == "--force" ]]; then
    __gs-warning "This will not make sure that your working branch is clean."
    __gs-print ""
    __gs-print "You will manually have to make sure that your branch name is unique. \n"
    confirm_message='Are you sure?'
    while true; do
      if [[ $SHELL == "/bin/zsh" ]]; then
        yn=""
        vared -p "$confirm_message (y\n)" yn
      else
        read -p "$confirm_message  (y\n)" yn
      fi
      case $yn in
        [Yy]* ) git checkout -b $1 && __gs-info "Make sure you run 'gs commit \"Commit message\"', followed by 'gs pull' afterwards (to merge the latest remote updates)." || __gs-error "Failed to checkout new branch '$1'"; break;;
        [Nn]* ) __gs-warning "Aborted."; break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
    return
  elif [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-uncommitted-changes-message
    return
  fi

  if [[ $1 == *" "* ]]; then
    __gs-error "ERROR:"
    __gs-error "\t Name can't contain spaces!"
    return
  fi

  git fetch origin
  # Check globally unique branch_name
  repo_branches="$(git branch --remote | grep -v "\->")" 2> /dev/null
  if [[ $repo_branches == *"origin/$1"* ]]; then
    __gs-error "A branch with name '$1' already exists."
    __gs-info "Please choose another branch name."
    return
  fi

  # Check that target_branch exists
  if [[ $repo_branches != *"origin/$2"* ]]; then
    __gs-error "Target branch with name '$2' does NOT exist."
    __gs-info "Please choose valid target branch."
    return
  fi

  base=$2
  branch=${base:-master}

  git checkout $branch

  pull_tail=$(git pull origin $branch 2> /dev/null | tail -n1)
  if [[ $pull_tail == *"Automatic merge failed"* ]]; then
   __gs-automatic-merge-failed $branch $branch
   __gs-warning "[WARNING] You're current branch is '$branch'!"
   return
  elif [[ $pull_tail == *"Already up-to-date"* ]]; then
    __gs-success "'$branch' already up-to-date."
  else
    __gs-success "Automatic merge with '$branch' successfull."
  fi

  git checkout -b $1
  git push origin $1
  echo ""
  __gs-print "Updated$PURPLE $branch$RESET, from repository."
  __gs-print "Created branch: $PURPLE $1 $RESET"
  __gs-print "Based of branch:$PURPLE $branch $RESET"
  __gs-success "[SUCCESS] $RESET Successfully created new feature branch named$PURPLE '$1'$RESET based of$PURPLE '$branch'$RESET"
  echo ""
}
