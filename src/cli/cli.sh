###########
#  cli   #
###########

gs() {
  __gs-read-config
  if [[ -z "$1" ]]; then
    __gs-error "Error requires at least one argument."
    __gs-help
  elif [[ $1 == "help" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    __gs_functions "$2" "-help"
  else
    __gs_functions "$@"
  fi
}

__gs_functions() {
  if   [[ $1 == "dev" ]] || [[ $1 == "feature" ]]; then
    __gs-dev "$2" "$3"
  elif [[ $1 == "pull" ]]; then
    __gs-pull "$2"
  elif [[ $1 == "commit" ]] || [[ $1 == "checkpoint" ]]; then
    __gs-checkpoint "$2"
  elif [[ $1 == "pre-commit" ]] || [[ $1 == "test" ]]; then
    __gs-precommit-hook "$2"
  elif [[ $1 == "package" ]] || [[ $1 == "build" ]]; then
    __gs-package "$2"
  elif [[ $1 == "done" ]] || [[ $1 == "release" ]]; then
    __gs-ready "$2" "$3"
  elif [[ $1 == "list" ]]; then
    __gs-list-commands "$2"
  elif [[ $1 == "diff" ]]; then
    __gs-diff "$2"
  elif [[ $1 == "switchto" ]] || [[ $1 == "branch" ]] || [[ $1 == "goto" ]]; then
    __gs-switchto "$2"
  elif [[ $1 == "history" ]] || [[ $1 == "repo-history" ]]; then
    __gs-history "$2"
  elif [[ $1 == "pull-request" ]] || [[ $1 == "open" ]] || [[ $1 == "github" ]]; then
    __gs-browse-project "$2"
  elif [[ $1 == "show" ]] || [[ $1 == "last" ]]; then
    __gs-show "$2"
  elif [[ $1 == "status" ]]; then
    __gs-status "$2"
  elif [[ $1 == "where" ]] || [[ $1 == "branches" ]]; then
    __gs-where "$2"
  elif [[ $1 == "stash" ]]; then
    __gs-stash "$2"
  elif [[ $1 == "stat" ]] || [[ $1 == "statistics" ]]; then
    __gs-stat "$2" "$3"
  elif [[ $1 == "abort_merge" ]] || [[ $1 == "abort-merge" ]] || [[ $1 == "abortmerge" ]]; then
    __gs-abort-merge "$2"
  elif [[ $1 == "get_update" ]] || [[ $1 == "get-update" ]] || [[ $1 == "getupdate" ]]; then
    __gs-update-source "$2"
  else
    __gs-error "Unknown command '$1'"
    __gs-help
  fi
}
