###########
#  proxy   #
###########

__gs-tag-release-help() {
  __gs-print "
usage:
  gs tag-release
lists all releases and prompts for a version number to tag the current branch with."
}

__gs-tag-release() {
  git fetch --tags
  __gs-print "Previous releases:"
  __gs-print "========================"
  git tag
  __gs-print "========================"
  __gs-print "Example tag: \n\t v0.9.1"

  version_prompt='What tag would you like to give this version?  (example: v0.9.1)'
  if [[ $SHELL == "/bin/zsh" ]]; then
    version_no=""
    vared -p "$version_prompt" version_no
  else
    read -p "$version_prompt " version_no
  fi

  if [[ $1 == *" "* ]]; then
    __gs-error "ERROR:"
    __gs-error "\t Tag must not contain spaces!"
    return
  fi

  git tag -a $version_no -m "Version $version_no" && \
  git push --tags && \
  __gs-success "Sucessfully tagged version: $version_no" || \
  __gs-error "Something went wrong creating the tag."
}

# Methods which pretty much just calls the eqvivalent git method

__gs-pull-help() {
  __gs-print "
usage:
\t gs pull <branch_name>
Download changes from remote <branch_name> branch to local workspace.
<branch_name> is optional, default: master.
note:"
  __gs-warning "\t Can cause merge conflicts"
}

__gs-pull() {
  if [[ $1 == "--help" ]]; then
    __gs-pull-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-uncommitted-changes-message
    return
  fi

  base=$1
  branch=${base:-master}
  __gs-print "Fetching $branch"
  git pull origin $branch && __gs-success "Updated and merged '$(git rev-parse --abbrev-ref HEAD)' with updates from '$branch'" || __gs-error "No remote branch found with name '$branch'"
}

__gs-checkpoint-help() {
  __gs-print "
usage:
\t gs commit 'Commit message'
Commit changes and push branch to remote"
}

__gs-checkpoint() {
  if [[ -z "$1" ]]; then
    __gs-error "You must provide a commit message"
    __gs-error "Missing argument 'Commit message'"
    __gs-checkpoint-help
    return
  fi
  if [[ $1 == "--help" ]]; then
    __gs-checkpoint-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-precommit-hook

    git add --all
    git commit -m "$1"
  else
    __gs-warning "No changes to commit."
  fi
}

__gs-diff-help() {
  __gs-print "
usage:
\t gs diff
shows all your uncommitted changes"
}

__gs-diff() {
  if [[ $1 == "--help" ]]; then
    __gs-diff-help
    return
  fi
  git status
  git diff
}

__gs-switchto-help() {
  __gs-print "
usage:
\t gs switchto <branch_name>
change the current workspace to <branch_name>
alias: branch, goto"
}

__gs-switchto() {
  if [[ $1 == "--help" ]]; then
    __gs-switchto-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-uncommitted-changes-message
    return
  fi
  git checkout $1
}

__gs-history-help() {
  __gs-print "
usage:
\t gs log <branch_name>
if no <branch_name> is provided the current branch history will be shown"
}

__gs-history() {
  if [[ $1 == "--help" ]]; then
    __gs-history-help
    return
  fi
  git log $1 --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
}

__gs-show-help() {
  __gs-print "
usage:
\t gs show <commit_sha>
\t gs show
if no <commit_sha> is provided the last commit in the current branch will be shown.
alias: last"
}

__gs-show() {
  if [[ $1 == "--help" ]]; then
    __gs-show-help
    return
  fi
  git show $1
}

__gs-status-help() {
  __gs-print "
usage:
\t gs status
show current git status"
}

__gs-status() {
  if [[ $1 == "--help" ]]; then
    __gs-status-help
    return
  elif [[ ! -z $1 ]]; then
    __gs-ignore-args "gs status"
  fi
  git status
}

__gs-where-help() {
  __gs-print "
  usage:
\t gs where
prints the current branch
Alias: branches"
}

__gs-where() {
  if [[ $1 == "--help" ]]; then
    __gs-where-help
    return
  elif [[ ! -z $1 ]]; then
    __gs-ignore-args "gs where"
  fi
  git branch
}

__gs-stash-help() {
    __gs-print "
usage:
\t gs stash <arg>
\t          push          # Save all changes to stash (alias: save)
\t          apply         # Apply all changes from latest stash (alias: pop)
\t          list          # List stash stack
\t          show          # Show the latest stash
\t          clear         # Clears the entire stash stack
Manage git-stash stack."
}

__gs-stash() {
  if [[ -z $1 ]]; then
    __gs-error "Needs argument."
    return
  elif [[ $1 == "--help" ]]; then
    __gs-stash-help
    return
  fi

  if [[ $1 == "push" ]] || [[ $1 == "save" ]]; then
    git stash save --all
  elif [[ $1 == "apply" ]] || [[ $1 == "pop" ]]; then
    git stash apply
  elif [[ $1 == "list" ]]; then
    git stash list
  elif [[ $1 == "show" ]]; then
    git stash show
  elif [[ $1 == "clear" ]]; then
    confirm_message='Are you sure you want to clear your entire stash?'
    while true; do
      if [[ $SHELL == "/bin/zsh" ]]; then
        yn=""
        vared -p "$confirm_message (y\n)" yn
      else
        read -p "$confirm_message  (y\n)" yn
      fi
      case $yn in
        [Yy]* ) git stash clear || __gs-error "Failed"; break;;
        [Nn]* ) __gs-warning "Aborted."; break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
    return
  else
    __gs-error "Unknown command '$1'"
  fi
}

__gs-abort-merge-help(){
  __gs-print "
usage:
\t gs abort-merge
aborts current merge.
alias: abort_merge, abortmerge
"
}
__gs-abort-merge() {
  if [[ "$1" == "--help" ]]; then
    __gs-update-source-help
    return
  elif [[ ! -z "$1" ]]; then
    __gs-print-args-ignored
  fi
  git merge --abort && __gs-success "Successfully aborted merge." || __gs-warning "No merge to abort."
}

__gs-fetch-all-remote-branches() {
  git fetch origin
  __gs-info "Fetching all branches."
  for remote in `git branch --remote | grep -v "\->"`; do
    __gs-fetch-remote-branch ${remote//origin\//} &
  done
  __gs-info "Fetched all branches."
}

__gs-fetch-remote-branch() {
  git fetch origin $1 || __gs-warning "Fetch of '$1' failed."
}
