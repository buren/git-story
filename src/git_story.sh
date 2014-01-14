git config --global color.ui auto

# Imports
source ~/.git-story/config.sh
source ~/.git-story/src/colors.sh
source ~/.git-story/src/utils.sh

########
#     CLI      #
########

gs() {
  __gs-read-config
  if [[ -z "$1" ]]; then
    __gs-error "Error requries at least one argument."
    __gs-help
  elif [[ $1 == "help" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs_functions "$2" "-help"
  else
    __gs_functions "$@"
  fi
}

__gs_functions() {
  if   [[ $1 == "dev" ]]; then
    __gs-dev "$2" "$3"
  elif [[ $1 == "pull" ]]; then
    __gs-pull "$2"
  elif [[ $1 == "commit" ]] || [[ $1 == "checkpoint" ]]; then
    __gs-checkpoint "$2"
  elif [[ $1 == "pre-commit" ]] || [[ $1 == "test" ]]; then
    __gs-precommit-hook
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
  elif [[ $1 == "stat" ]]; then
    __gs-stat "$2" "$3"
  else
    __gs-error "Unknown command '$1'"
    __gs-help
  fi
}

__gs-read-config() {
  config_path="$(git rev-parse --show-toplevel)/.gitstoryrc"
  if [[ -f $config_path ]]; then
    source $config_path
  fi
}

###########
#  FUNCTIONS   #
###########
function __gs-stat-help {
  __gs-print "
usage:
\t gs stat <type>
prints statistics of given type.
Alias: statistics
Available types are: commits, contributions (alias: contrib).

example:
\t gs stat contributions
Default: contributions"
}

function __gs-stat {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-stat-help
    return
  elif [[ -z "$1" ]] || [[ "$1" == "contributions" ]] || [[ "$1" == "contrib" ]]; then
    if [[ -z $2 ]] || [[ "$2" == "each" ]]; then
      __gs-error "Doesn't correctly print total number of commits.."
      $author_list | while read line; do
        __gs-stat-author-contrib "${line}"
      done
    else
      __gs-stat-author-contrib "$2"
    fi
  elif [[ "$1" == "commits" ]] || [[ "$1" == "commit" ]]; then
    if [[ ! -z "$2" ]]; then
      __gs-ignore-args "gs stat $1 $2"
    fi
    __gs-stat-commits
  else
    __gs-error "Error '$1' unrecognized argument."
    __gs-stat-help
  fi
}

function __gs-list-authors {
  git log --format='%aN' | sort -u
}

function __gs-stat-commits {
  git shortlog --summary --numbered --no-merges
}

function __gs-stat-author-contrib {
  if [[ "$1" == "total" ]]; then
    __gs-print "Contributions by all authors:"
    git log --pretty=tformat: --numstat | awk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END \
    { printf "added lines:   %s \nremoved lines: %s \ntotal lines:   %s\n",add,subs,loc }' -
  elif [[ ! -z "$1" ]]; then
    # echo "$(git shortlog --summary --numbered --no-merges)"
    __gs-print "Contributions by: $PURPLE$1$WHITE"
    git log --author="$1" --pretty=tformat: --numstat | awk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END \
    { printf "added lines:   %s \nremoved lines: %s \ntotal lines:   %s\n",add,subs,loc }' -
    # Print number of commits
    # echo "start"
    # al=$(__gs-stat-commits); echo "al is: $al"
    # echo "$(git shortlog --summary --numbered --no-merges)"
    # echo "stop"
    __gs-stat-commits | grep -i "$@" | cut -f1 | tr -d ' ' | awk '{ commits = $1 ;} END \
            { printf "commits:   %s \n",commits }' -
    number_of_commits=$(__gs-stat-commits | grep -i "$@" | cut -f1 | tr -d ' ' | awk '{ commits = $1 ;} END \
        { printf "commits:   %s \n",commits }' -)
    # echo "static:"
    # echo $number_of_commits
    echo ""
  else
    __gs-error "[BUG] No argument supplied for __gs-stat-author-contrib."
    __gs-stat-help
  fi
}

__gs-github-open-help() {
  __gs-print "
usage:
\t gs pull-request
opens current projects GitHub page"
}

alias github_open="open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"
__gs-github-open() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-github-open-help
    return
  elif [[ ! -z "$1" ]]; then
    __gs-ignore-args "gs pull-request"
  fi
  github_open
}

__gs-dev-help() {
  __gs-print "
description:
\t start implenting your feature.
usage:
\t gs dev <branch_name> <base_branch>
<base_branch> is optional and will fall back to master

Guarantees clean workspace from remote master (or specified branch)"
}

__gs-dev() {
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
    __gs-error >&2 "Branch $PURPLE'$1'$RESET already exists."
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
      __gs-print "Specified base branch: $PURPLE'$2'$RESET not found!"
      __gs-print "Please specifiy a valid base branch."
      __gs-print "Available branches are:"
      git branch
      __gs-error "ERROR: No such base branch$PURPLE '$2' $RESET"
      return
    fi
  fi
  base=$2
  branch=${base:-master}

  git checkout $branch
  git pull origin $branch
  git checkout -b $1
  git push origin $1
  __gs-print "Updated$PURPLE $branch$RESET, from repository."
  __gs-print "Created branch: $PURPLE $1 $RESET"
  __gs-print "Based of branch:$PURPLE $branch $RESET"
  __gs-success "[SUCCESS] $RESET Successfully created new feature branch named$PURPLE '$1' $RESET based of $PURPLE '$branch' $RESET"
  echo ""
}

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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-checkpoint-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __gs-precommit-hook

    git add --all
    git commit -m "$1"
    __gs-info "Ran all tests. Check status."
  else
    __gs-warning "No changes to commit."
  fi
}

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

__gs-ready() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-ready-help
    return
  fi

  __gs-precommit-hook

  if [[ $PRINT_CHECKLIST == true ]]; then
    __gs-ready-checklist-print
    confirm_message="Have you answered yes to all of the above?"
  else
    confirm_message="Are your sure?"
  fi

  while true; do
    read -p "$confirm_message  (y\n)" yn
    case $yn in
      [Yy]* ) __gs-ready-execute "$@"; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done

}

__gs-ready-execute() {
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

  if [[ $HAS_GITHUB == true ]]; then
    while true; do
      read -p "Would you like to open GitHub? (y\n)" yn
      case $yn in
        [Yy]* ) __gs-github-open; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
  fi
}

__gs-precommit-hook-help() {
  __gs-print "
To set global pre-commit command edit ~/.git-story/config.sh.

To set project specific pre-commit command create '.gitstoryrc' at git root.
View ~/.git-story/config.sh for available config options."
}

__gs-precommit-hook() {
  if [[ "$1" == "-help" ]] ||  [[ "$1" == "--help" ]]; then
    __gs-precommit-hook
    return
  fi

  if [[ ! -z $PRE_COMMIT_HOOK ]]; then
    $PRE_COMMIT_HOOK
  else
    __gs-print "No pre-commit-hook set. Skipping..."
  fi
}

__gs-diff-help() {
  __gs-print "
usage:
\t gs diff
shows all your uncommitted changes"
}

__gs-diff() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-history-help
    return
  fi
  git log $1
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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-status-help
    return
  elif [[ -z $1 ]]; then
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
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-where-help
    return
  elif [[ -z $1 ]]; then
    __gs-ignore-args "gs where"
  fi
  git branch
}

__gs-uncommitted-changes-message() {
  __gs-warning "
You have uncommited changes.
Please commit or stash you're changes before implementing you're new feature.
Commit your changes:"
  __gs-checkpoint-help
}



################
#             HELP               #
################

__gs-help() {
  __gs-print "Run any command followed by '-help' or '--help' for command details."
  __gs-list-commands
  __gs-print "
help:
\t gs 'command' -help
usage:
\t gs dev story23
\t gs done 'Implemented Story 23'"
}

__gs-list-commands() {
  __gs-print "
gs commands:
\t dev                 Start developling a new feature
\t pull                 Download changes from remote branch to local workspace
\t commit           Commit changes and push branch to remote (alias: checkpoint)
\t done               Commit changes and sync with remote
\t switchto          Switch from current branch to specified branch
\t diff                  List uncomitted changes
\t pull-request    Open current git repository on Github (alias: open)
\t status              Shows the current git status
\t where              Shows all available branches (alias: branches)"
}

__gs-ready-checklist-print() {
  __gs-warning "
Checklist:
\t 1. Have you written tests?
\t 2. Do all tests pass?
\t 3. Have you refactored your code?
\t 4. Are you ready for possible merge conflicts?"
  echo ""
}
