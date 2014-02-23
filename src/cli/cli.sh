###########
#  cli   #
###########

__gs_functions() {
  cmd=$1
  prim_arg="$2"
  sec_arg="$3"
  args=( $@ )
  case $prim_arg in
    "help" | "-help" | "--help" )
      prim_arg="--help"
      ;;
  esac

  case $cmd in
    "dev" | "feature" )
      __gs-dev "$prim_arg" "$sec_arg"
      ;;
    "pull" )
      __gs-pull "$prim_arg" "$sec_arg"
      ;;
    "commit" | "checkpoint" )
      __gs-checkpoint "$prim_arg" "$sec_arg"
      ;;
    "pre-commit" | "test" )
      __gs-precommit-hook "$prim_arg" "$sec_arg"
      ;;
    "package" | "build" )
      __gs-package "$prim_arg" "$sec_arg"
      ;;
    "release" )
      __gs-release "$prim_arg" "$sec_arg"
      ;;
    "tag_release" | "tag-release" | "tagrelease" )
      __gs-tag-release "$prim_arg" "$sec_arg"
      ;;
    "done")
      __gs-ready "$prim_arg" "$sec_arg"
      ;;
    "list" )
      __gs-list-commands "$prim_arg" "$sec_arg"
      ;;
    "diff" )
      __gs-diff "$prim_arg" "$sec_arg"
      ;;
    "switchto" | "branch" | "goto" )
      __gs-switchto "$prim_arg" "$sec_arg"
      ;;
    "history" | "repo-history" )
      __gs-history "$prim_arg" "$sec_arg"
      ;;
    "open" | "pull-request" | "github" )
      __gs-browse-project "$prim_arg" "$sec_arg"
      ;;
    "show" | "last" )
      __gs-show "$prim_arg" "$sec_arg"
      ;;
    "status" )
      __gs-status "$prim_arg" "$sec_arg"
      ;;
    "where" | "branches" )
      __gs-where "$prim_arg" "$sec_arg"
      ;;
    "stash" )
      __gs-stash "$prim_arg" "$sec_arg"
      ;;
    "stat" | "statistics" )
      __gs-stat "$prim_arg" "$sec_arg"
      ;;
    "abort_merge" | "abort-merge" | "abortmerge" )
      __gs-abort-merge "$prim_arg" "$sec_arg"
      ;;
    "get_update" | "get-update" | "getupdate" )
      __gs-update-source "$prim_arg" "$sec_arg"
      ;;
    *)
      __gs-help
      __gs-error "Unknown command '$1'"
      ;;
  esac
}
