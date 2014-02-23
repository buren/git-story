###########
#  integration   #
###########

# project integration commands

__gs-browse-project-help() {
  __gs-print "
usage:
\t gs open
opens current project page
alias: pull-request, github"
}

__gs-browse-project() {
  if [[ $1 == "--help" ]]; then
    __gs-browse-project-help
    return
  elif [[ ! -z "$1" ]]; then
    __gs-ignore-args "gs open"
  fi

  # Check path
  if [[ ! -z $GS_PROJECT_URL ]]; then
    url=$GS_PROJECT_URL
  elif [[ $GS_HAS_GITHUB == true ]]; then
    url=$(git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//')
  fi

  # Check OS
  if [[ "$(uname -s)" == "Linux" ]]; then
    xdg-open $url &
  elif [ "$(uname)" == "Darwin" ]; then
    open $url &
  fi
}


__gs-precommit-hook-help() {
  __gs-print "
To set global pre-commit command edit ~/.git-story/config.sh.

To set project specific pre-commit command create '.gitstoryrc' at git root.
View ~/.git-story/config.sh for available config options."
}

__gs-precommit-hook() {
  if [[ "$1" == "--help" ]]; then
    __gs-precommit-hook
    return
  fi

  if [[ ! -z $GS_PRE_COMMIT_HOOK ]]; then
    __gs-info "Running pre-commit hook."
    eval $GS_PRE_COMMIT_HOOK
    __gs-info "Ran all tests. Check status."
  else
    __gs-print "No pre-commit-hook set. Skipping..."
  fi
}

__gs-package-help() {
  __gs-print "Usage:
\t gs package
Runs GS_PACKAGE command, if specified.
alias: build"
}

__gs-package() {
  if [[ $1 == "--help" ]]; then
    __gs-package-help
    return
  fi
  if [[ ! -z $GS_PACKAGE ]]; then
    __gs-info "Packaging project."
    eval $GS_PACKAGE
    __gs-info "Done"
  fi
}


__gs-release-help() {
  __gs-print "Usage:
\t gs release
Runs GS_RELEASE command, if specified.
"
}

__gs-release() {
  if [[ $1 == "--help" ]]; then
    __gs-release-help
    return
  fi
  if [[ ! -z $GS_RELEASE ]]; then
    __gs-info "Packaging project."
    eval $GS_RELEASE
    __gs-info "Done"
  fi
}
