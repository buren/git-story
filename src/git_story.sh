git config --global color.ui auto

########
#     CLI      #
########

function gs {
  if    [[ -z "$1" ]]; then
    __gs-help
  elif [[ $1 == "help" ]]; then
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
  elif [[ $1 == "checkpoint" ]]; then
    __gs-checkpoint "$2"
  elif [[ $1 == "done" ]]; then
    __gs-ready "$2"
  elif [[ $1 == "release" ]]; then
    __gs-release "$2"
  elif [[ $1 == "list" ]]; then
    __gs-list-commands "$2"
  elif [[ $1 == "diff" ]]; then
    __gs-diff "$2"
  elif [[ $1 == "switchto" ]]; then
    __gs-switchto "$2"
  elif [[ $1 == "history" ]]; then
  __gs-history "$2"
  elif [[ $1 == "show" ]] || [[ $1 == "last" ]]; then
    __gs-show "$2"
  elif [[ $1 == "where" ]]; then
  __gs-where "$2"
  else
    echo "Unknown command '$1'"
    __gs-help
  fi
}

###########
#  FUNCTIONS   #
###########

function __gs-dev-help {
  echo -e "description: "
  echo -e "\t start implenting your feature."
  echo -e "usage: "
  echo -e "\t gs dev a_branch_name base_branch # base_branch is optional"
  echo "base_branch is optional and will fall back to master"
  echo -e "\t guarantees clean workspace from remote master (or specified branch)"
}

function __gs-dev {
  if [[ -z "$1" ]]; then
    echo "You must provide a branch name"
    echo "Missing argument <branch_name>"
    __gs-dev-help
    return
  fi
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-dev-help
    return
  fi

  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __uncommitted-changes-message
    return
  fi
  base=$2
  branch=${base:-master}
  echo "Base branch: $branch"
  git checkout $branch
  gitremote=git show-ref --verify --quiet "refs/heads/$branch"
  echo "Updating $branch, from repository."
  git pull origin $branch
  echo "Creating branch: $1"
  git checkout -b $1
  git branch
  echo -e "You're now ready to implement your feature"
  echo "Based of: $branch branch"
  echo "Current branch $1"
}

function __gs-update-help {
  echo -e "usage: "
  echo -e "\t gs update"
  echo -e "Download changes from remote master branch to local workspace"
  echo -e "! Can cause merge conflicts"
}

function __gs-update {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
      __gs-update-help
    return
  fi
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    __uncommitted-changes-message
  else
    git pull origin master
  fi
}

function __gs-checkpoint-help {
  echo -e "usage: "
  echo -e "\t gs checkpoint 'Commit message'"
  echo -e "Commit changes and push branch to remote"
}

function __gs-checkpoint {
  if [[ -z "$1" ]]; then
    echo "You must provide a commit message"
    echo "Missing argument 'Commit message'"
    __gs-checkpoint-help
    return
  fi
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-checkpoint-help
  else
    if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
      git add --all
      git commit -m "$1"
    else
      echo "No changes to commit."
    fi
  fi
}

function __gs-ready-help {
  echo -e "usage: "
  echo -e "\t gs done"
  echo "only if all changes have been committed."
  echo "otherwise run:"
  echo -e "\t gs done 'Commit message'"
  echo -e "commit message example: "
  echo -e "\t 'Implemented story 13."
  echo -e "\t Updated FileReaderInterface."
  echo -e "\t Fixed merge conflict."
  echo -e "\t etc.....'"
  echo -e "note: "
  echo -e "\t ! Can cause merge conflicts"
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
      [Yy]* ) __gs-ready-execute "$1"; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

function __gs-ready-execute {
  if [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]; then
    if [[ -z "$1" ]]; then
      echo "You have uncommited changes you must provide a commit message."
      __gs-ready-help
      return
    fi
    git add --all
    git commit -m "$1"
  fi
  local BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git push origin $BRANCH
  git pull origin master
  echo -e "If any merge conflicts fix them and then run:"
  echo -e "\t gs checkpoint 'message'"
  echo -e "If no conflicts:"
  echo -e "\t gs release"
}

function __gs-release {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
     __gs-release-help
     return
  fi
  while true; do
    read -p "Are you sure you want to release? (y\n)" yn
    case $yn in
      [Yy]* ) __gs-release-execute; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

function __gs-release-help {
  echo -e "usage: "
  echo -e "\t gs release"
  echo -e "pushes your committed changes to the repository."
}

function __gs-release-execute {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ $BRANCH == "master" ]; then
    git push origin master
  else
    echo -e "Cannot release from branch $($CURRENT_BRANCH)."
    echo -e "Can only release from master branch."
    echo -e "Did you forget to run 'gs done'?"
    echo -e "help: "
    echo -e "\t gs help"
    echo "or for a specific command"
    echo -e "\t gs help 'command'"
  fi
}

function __gs-diff-help {
  echo "usage: "
  echo -e "\t gs diff"
  echo "shows all your uncommitted changes"
}

function __gs-diff {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-diff-help
    return
  fi
  git diff
}

function __gs-switchto-help {
  echo "usage: "
  echo -e "\t gs switchto branch_name"
  echo "change the current workspace to branch_name"
}

function __gs-switchto {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-switchto-help
    return
  fi
  git checkout $1
}

function __gs-history-help {
  echo "usage:"
  echo -e "\t gs log <branch_name>"
  echo "if no <branch_name> is provided the current branch history will be shown"
}

function __gs-history {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-history-help
    return
  fi
  git log $1
}

function __gs-show-help {
  echo "usage: "
  echo -e "\t gs show <commit_sha>"
  echo -e "'\t gs last <commit_sha>"
  echo "if no <commit_sha> is provided the last commit in the current branch will be shown"
  echo "last (is an alias)"
}

function __gs-show {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-show-help
    return
  fi
  git show $1
}

function __gs-where-help {
  echo "usage: "
  echo -e "\t gs where"
  echo "prints the current branch"
}

function __gs-where {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs-where-help
    return
  fi
  git branch
}

function __uncommitted-changes-message {
  echo -e "You have uncommited changes."
  echo -e "Please commit or stash you're changes before implementing you're new feature."
  echo "Perhaps create a checkpoint:"
  __gs-checkpoint-help
}


################
#             HELP               #
################

function __gs-help {
  echo -e "Run any command followed by 'help' for command details."
  __gs-list-commands
  echo -e "help: "
  echo -e "\t gs 'command' -help"
  echo -e "usage: "
  echo -e "\t gs dev story23"
  echo -e "\t gs done 'Implemented Story 23'"
  echo -e "\t gs release"
}

function __gs-list-commands {
  echo ""
  echo "gs commands: "
  echo -e "\t dev              Start developling a new feature"
  echo -e "\t update           Download changes from remote master branch to local workspace"
  echo -e "\t checkpoint       Commit changes and push branch to remote"
  echo -e "\t done             Commit changes and sync with remote master branch"
  echo -e "\t release          Pushes your committed changes to remote master branch"
}

function __gs-ready-checklist-print {
  echo "Checklist:"
  echo -e "\t 1. Have you written tests?"
  echo -e "\t 2. Do all tests pass?"
  echo -e "\t 3. Have you refactored your code?"
  echo -e "\t 4. Are you ready for possible merge conflicts?"
  echo ""
}
