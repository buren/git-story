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
    __gs_functions "$1" "$2"
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
  else
    if [[ $1 == "-help" ]]; then
      __gs-dev-help
    else
      local branch=${2-master}
      git checkout $branch
      git pull origin $branch
      git checkout -b $1
      git branch
      echo -e "You're now ready to implement your feature"
    fi
  fi
}

function __gs-update-help {
  echo -e "usage: "
  echo -e "\t gs update"
  echo -e "Download changes from remote master branch to local workspace"
  echo -e "! Can cause merge conflicts"
}

function __gs-update {
  if [[ $1 == "-help" ]]; then
      __gs-update-help
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
    echo "Missing argument <'Commit message'>"
    __gs-checkpoint-help
  else
    if [[ $1 == "-help" ]]; then
      __gs-checkpoint-help
    else
      git add --all
      git commit -m "$1"
    fi
  fi
}

function __gs-ready-help {
  echo -e "usage: "
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
  if [[ $1 == "-help" ]]; then
      __gs-ready-help
  else
      __gs-ready-checklist-print
    while true; do
      read -p "Have you answered yes to all of the above? (y\n)" yn
      case $yn in
        [Yy]* ) __gs-ready-execute "$1"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
  fi
}

function __gs-ready-execute {
  if [[ -z "$1" ]]; then
    echo "You must provide a commit message!"
    __gs-ready-help
  else
    git add --all
    git commit -m "$1"
    local BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git push origin $BRANCH
    git checkout master
    git pull origin master
    git merge $BRANCH
    echo -e "If any merge conflicts fix them and run:"
    echo -e "\t gs checkpoint 'message'"
    echo -e "If no conflicts:"
    echo -e "\t gs release"
  fi
}

function __gs-release {
  if [[ $1 == "-help" ]]; then
      __gs-release-help
  else
    while true; do
      read -p "Are you sure you want to release? (y\n)" yn
      case $yn in
        [Yy]* ) __gs-release-execute; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
  fi
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
  if [[ $1 == "-help" ]]; then
    __gs-diff-help
  else
    git diff
  fi
}

function __gs-switchto-help {
  echo "usage: "
  echo -e "\t gs switchto branch_name"
  echo "change the current workspace to branch_name"
}

function __gs-switchto {
  if [[ $1 == "-help" ]]; then
    __gs-switchto-help
  else
    git checkout $1
  fi
}

function __gs-history-help {
  echo "usage:"
  echo -e "\t gs log <branch_name>"
  echo "if no <branch_name> is provided the current branch history will be shown"
}

function __gs-history {
  if [[ $1 == "-help" ]]; then
    __gs-history-help
  else
    git log $1
  fi
}

function __gs-show-help {
  echo "usage: "
  echo -e "\t gs show <commit_sha>"
  echo -e "'\t gs last <commit_sha>"
  echo "if no <commit_sha> is provided the last commit in the current branch will be shown"
  echo "last (is an alias)"
}

function __gs-show {
  if [[ $1 == "-help" ]]; then
    __gs-show-help
  else
    git show $1
  fi
}

function __gs-where-help {
  echo "usage: "
  echo -e "\t gs where"
  echo "prints the current branch"
}

function __gs-where {
  if [[ $1 == "-help" ]]; then
    __gs-where-help
  else
    git branch
  fi
}


################
#             HELP               #
################

function __gs-help {
  echo -e "Run any command followed by 'help' for command details."
  __gs-list-commands
  echo -e "help: "
  echo -e "\t gs 'command' help"
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
