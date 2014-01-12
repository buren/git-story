git config --global color.ui auto

# Imports
source ~/.git-story/src/colors.sh
source ~/.git-story/src/utils.sh

########
#     CLI      #
########

function gs {
  if [[ -z "$1" ]]; then
    __gs-error "Error requries at least one argument."
    __gs-help
  elif [[ $1 == "help" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs_functions "$2" "-help"
  else
    __gs_functions "$@"
  fi
}

function __gs_functions {
  if   [[ $1 == "dev" ]]; then
    __gs-dev "$2" "$3"
  elif [[ $1 == "update" ]]; then
    __gs-update "$2"
  elif [[ $1 == "commit" ]] || [[ $1 == "checkpoint" ]]; then
    __gs-checkpoint "$2"
  elif [[ $1 == "done" ]]; then
    __gs-ready "$2" "$3"
  elif [[ $1 == "list" ]]; then
    __gs-list-commands "$2"
  elif [[ $1 == "diff" ]]; then
    __gs-diff "$2"
  elif [[ $1 == "switchto" ]] || [[ $1 == "branch" ]] || [[ $1 == "goto" ]]; then
    __gs-switchto "$2"
  elif [[ $1 == "history" ]] || [[ $1 == "repo-history" ]]; then
    __gs-history "$2"
  elif [[ $1 == "pull-request" ]] || [[ $1 == "open" ]]; then
    __gs-github-open "$2"
  elif [[ $1 == "show" ]] || [[ $1 == "last" ]]; then
    __gs-show "$2"
  elif [[ $1 == "status" ]]; then
    __gs-status "$2"
  elif [[ $1 == "where" ]] || [[ $1 == "branches" ]]; then
  __gs-where "$2"
  else
    __gs-error "Unknown command '$1'"
    __gs-help
  fi
}

###########
#  FUNCTIONS   #
###########

function __gs-github-open {
  __gs-print "
usage:
\t gs pull-request
opens current git-projects GitHub page"
}

alias github_open="open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"
function __gs-github-open {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-github-open
    return
  elif [[ ! -z "$1" ]]; then
    __gs-ignore-args "gs pull-request"
  fi
  github_open
}

function __gs-dev-help {
  __gs-print "
description:
\t start implenting your feature.
usage:
\t gs dev <branch_name> <base_branch>
<base_branch> is optional and will fall back to master

Guarantees clean workspace from remote master (or specified branch)"
}

function __gs-dev {
  if [[ -z "$1" ]]; then
    __gs-error "You must provide a branch name"
    __gs-error "Missing argument <branch_name>"
    __gs-dev-help
    return
  elif [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-dev-help
    return
  elif [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-uncommitted-changes-message
    return
  fi

  git fetch origin

  __gs-print "Verifying unique name for branch."
  if git show-ref --verify --quiet "refs/heads/$1"; then
    __gs-error >&2 "Branch $PURPLE'$1'$WHITE already exists."
    __gs-error "Please choose another branch name."
    return
  else
    echo ""
    __gs-print "No conflicting branches found."
    __gs-print "Proceeding..."
  fi

  if [[ ! -z "$2" ]]; then
    if git show-ref --verify --quiet "refs/heads/$2"; then
      __gs-print >&2 "Base branch '$2' exists."
      __gs-print "Proceeding..."
    else
      __gs-print "Specified base branch: $PURPLE'$2'$WHITE not found!"
      __gs-print "Please specifiy a valid base branch."
      __gs-print "Available branches are:"
      git branch
      __gs-error "ERROR: No such base branch$PURPLE '$2' $WHITE"
      return
    fi
  fi
  base=$2
  branch=${base:-master}

  git checkout $branch
  git pull origin $branch
  git checkout -b $1
  git push origin $1
  __gs-print "Updated$PURPLE $branch$WHITE, from repository."
  __gs-print "Created branch: $PURPLE $1 $WHITE"
  __gs-print "Based of branch:$PURPLE $branch $WHITE"
  __gs-success "[SUCCESS] $WHITE Successfully created new feature branch named$PURPLE '$1' $WHITE based of $PURPLE '$branch' $WHITE"
  echo ""
}

function __gs-update-help {
  __gs-print "
usage:
\t gs update
Download changes from remote master branch to local workspace
note:"
  __gs-warning "\t Can cause merge conflicts"
}

function __gs-update {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-update-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-uncommitted-changes-message
  fi

  base=$1
  branch=${base:-master}
  __gs-print "Fetching $branch"
  git pull origin $branch && __gs-success "Updated and merged '$(git rev-parse --abbrev-ref HEAD)' with updates from '$branch'" || __gs-error "No remote branch found with name '$branch'"
}

function __gs-checkpoint-help {
  __gs-print "
usage:
\t gs commit 'Commit message'
Commit changes and push branch to remote"
}

function __gs-checkpoint {
  if [[ -z "$1" ]]; then
    __gs-error "You must provide a commit message"
    __gs-error "Missing argument 'Commit message'"
    __gs-checkpoint-help
    return
  fi
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-checkpoint-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    git add --all
    git commit -m "$1"
  else
    __gs-warning "No changes to commit."
  fi
}

function __gs-ready-help {
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

function __gs-ready {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-ready-help
    return
  fi
  __gs-ready-checklist-print
  while true; do
    read -p "Have you answered yes to all of the above? (y\n)" yn
    case $yn in
      [Yy]* ) __gs-ready-execute "$@"; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

function __gs-ready-execute {
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    if [[ -z "$1" ]]; then
      __gs-error "You have uncommited changes you must provide a commit message."
      __gs-ready-help
      return
    fi
    git add --all
    git commit -m "$1"
  else
    __gs-warning "Nothing to commit. Ignoring arguments."
  fi

  local current="$(git rev-parse --abbrev-ref HEAD)"
  git push origin $current
  target=${2:-master}
  git pull origin $target
  git push origin $current
  __gs-warning "If any merge conflicts fix them and then run:"
  __gs-print "\t gs done 'Fixed merge conflicts.'"
  echo ""
  __gs-success "Successfully pulled updates from remote '$target' branch."
  echo ""
  while true; do
    read -p "Would you like to open GitHub? (y\n)" yn
    case $yn in
      [Yy]* ) __gs-github-open; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

function __gs-diff-help {
  __gs-print "
usage:
\t gs diff
shows all your uncommitted changes"
}

function __gs-diff {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-diff-help
    return
  fi
  git diff
}

function __gs-switchto-help {
  __gs-print "
usage:
\t gs switchto <branch_name>
change the current workspace to <branch_name>
alias: branch, goto"
}

function __gs-switchto {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-switchto-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-uncommitted-changes-message
    return
  fi
  git checkout $1 && __gs-success "Successfully switched to branch $PURPLE'$1'$WHITE"
}

function __gs-history-help {
  __gs-print "
usage:
\t gs log <branch_name>
if no <branch_name> is provided the current branch history will be shown"
}

function __gs-history {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-history-help
    return
  fi
  git log $1
}

function __gs-show-help {
  __gs-print "
usage:
\t gs show <commit_sha>
\t gs show
if no <commit_sha> is provided the last commit in the current branch will be shown.
alias: last"
}

function __gs-show {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-show-help
    return
  fi
  git show $1
}

function __gs-status-help {
  __gs-print "
usage:
\t gs status
show current git status"
}

function __gs-status {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-status-help
    return
  elif [[ -z $1 ]]; then
    __gs-ignore-args "gs status"
  fi
  git status
}

function __gs-where-help {
  __gs-print "
  usage:
\t gs where
prints the current branch
Alias: branches"
}

function __gs-where {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-where-help
    return
  elif [[ -z $1 ]]; then
    __gs-ignore-args "gs where"
  fi
  git branch
}

function __gs-uncommitted-changes-message {
  __gs-warning "
You have uncommited changes.
Please commit or stash you're changes before implementing you're new feature.
Commit your changes:"
  __gs-checkpoint-help
}



################
#             HELP               #
################

function __gs-help {
  __gs-print "Run any command followed by '-help' or '--help' for command details."
  __gs-list-commands
  __gs-print "
help:
\t gs 'command' -help
usage:
\t gs dev story23
\t gs done 'Implemented Story 23'"
}

function __gs-list-commands {
  __gs-print "
gs commands:
\t dev              Start developling a new feature
\t update           Download changes from remote master branch to local workspace
\t commit           Commit changes and push branch to remote (alias: checkpoint)
\t done             Commit changes and sync with remote
\t switchto         Switch from current branch to specified branch
\t diff             List uncomitted changes
\t pull-request     Open current git repository on Github (alias: open)
\t status           Shows the current git status
\t where            Shows all available branches (alias: branches)"
}

function __gs-ready-checklist-print {
  __gs-warning "
Checklist:
\t 1. Have you written tests?
\t 2. Do all tests pass?
\t 3. Have you refactored your code?
\t 4. Are you ready for possible merge conflicts?"
  echo ""
}
