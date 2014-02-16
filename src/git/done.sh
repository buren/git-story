###########
#  done   #
###########

__gs-ready-help() {
  __gs-print "
usage:
\t gs done
only if all changes have been committed.
otherwise run:
\t gs done 'Commit message' <target_branch>
will fetch and merge <target_branch>. <target_branch> is optional and defaults to 'master'.

Commit message example:
\t 'Implemented story 13.
\t Updated FileReaderInterface.
\t Fixed merge conflict.
\t etc.....'

note:"
  __gs-warning "\t Can cause merge conflicts"
}

__gs-print-merged-run-hook-message() {
  __gs-info "Remote changes from '$1' merged."
  __gs-info "Running pre-commit hook."
}

__gs-ready() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-ready-help
    return
  fi

  __gs-precommit-hook

  if [[ $GS_PRINT_CHECKLIST == true ]]; then
    __gs-ready-checklist-print
    confirm_message="Have you answered yes to all of the above?"
  else
    confirm_message="Are your sure?"
  fi

  echo ""

  if [[ $GS_PRINT_CHECKLIST != true ]] && [[ $GS_PROMPT_ON_DONE  == false ]]; then
    __gs-ready-execute "$@"
  else
    while true; do
      if [[ $SHELL == "/bin/zsh" ]]; then
        yn=""
        vared -p "$confirm_message (y\n)" yn
      else
        read -p "$confirm_message  (y\n)" yn
      fi
      case $yn in
        [Yy]* ) __gs-ready-execute "$@"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
    return
  fi
}

__gs-ready-execute() {
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    if [[ -z "$1" ]]; then
      __gs-error "You have uncommited changes you must provide a commit message."
      return
    fi
    git add --all
    git commit -m "$1"
  elif [[ ! -z "$1" ]]; then
    __gs-warning "Nothing to commit. Ignoring arguments."
  fi
  # Update current branch
  local current="$(git rev-parse --abbrev-ref HEAD)"
  # Pull from remote
  __gs-info "\nPull from: '$current'"
  pull_tail=$(git pull origin $current 2> /dev/null | tail -n1)
  if [[ $pull_tail == *"Automatic merge failed"* ]]; then
   __gs-automatic-merge-failed $current $current
   return
  elif [[ $pull_tail == *"Already up-to-date"* ]]; then
    __gs-info "'$current' already up-to-date."
  else
    __gs-print-merged-run-hook-message $current
    __gs-precommit-hook
    if [[ ! -z $GS_PRE_COMMIT_HOOK ]]; then
      while true; do
        if [[ $SHELL == "/bin/zsh" ]]; then
          yn=""
          vared -p "$confirm_message (y\n)" yn
        else
          read -p "Did all tests pass? (y\n)" yn
        fi
        case $yn in
          [Yy]* ) __gs-success "All tests pass. Resuming 'gs done'."; break;;
          [Nn]* ) __gs-warning "Aborting 'gs done'. Fix all tests.."; return; break;;
          * ) echo "Please answer yes or no.";;
        esac
      done
    fi
  fi
  __gs-info "\n[push]"
  git push origin $current

  # Update target branch
  local target=${2:-master}
  # Pull from remote
  __gs-info "\nPull from: '$target'"
  target_pull_tail=$(git pull origin $target 2> /dev/null | tail -n1)
  if [[ $target_pull_tail == *"Automatic merge failed"* ]]; then
   __gs-automatic-merge-failed $target $current
   return
  elif [[ $target_pull_tail == *"Already up-to-date"* ]]; then
    __gs-info "'$target' already up-to-date."
  else
    __gs-print-merged-run-hook-message $target
    __gs-precommit-hook
    if [[ ! -z $GS_PRE_COMMIT_HOOK ]]; then
      while true; do
        if [[ $SHELL == "/bin/zsh" ]]; then
          yn=""
          vared -p "$confirm_message (y\n)" yn
        else
          read -p "Did all tests pass? (y\n)" yn
        fi
        case $yn in
          [Yy]* ) __gs-success "All tests pass. Resuming 'gs done'."; break;;
          [Nn]* ) __gs-warning "Aborting 'gs done'. Fix all tests.."; return; break;;
          * ) echo "Please answer yes or no.";;
        esac
      done
    fi
  fi
  __gs-info "\n[push]"
  git push origin $current # Push merged updates from target branch to current

  echo ""
  __gs-success "Successfully pulled updates from remote '$target' branch."
  echo ""

  if [[ $GS_PROMPT_BROWSE_URL == true ]]; then
    local prompt_message="Would you like to open your projects website? (y\n)"
    while true; do
      if [[ $SHELL == "/bin/zsh" ]]; then
        yn=""
        vared -p "$prompt_message" yn
      else
        read -p "$prompt_message" yn
      fi
      case $yn in
        [Yy]* ) __gs-browse-project; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
  fi
}
