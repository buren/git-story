###########
#  messages   #
###########

__gs-uncommitted-changes-message() {
  __gs-warning "
You have uncommited changes.
Please commit or stash you're changes before implementing you're new feature.
Commit your changes:"
  __gs-checkpoint-help
}

__gs-automatic-merge-failed() {
  __gs-print "Automatic merge with branch '$1' to '$2' failed."
  __gs-error "Merge with '$1' failed."
  __gs-info "Please fix all conflicts and then run 'gs done \"Fixed merge conflicts\"'."
}

__gs-print-args-ignored() {
  __gs-info "Function does not take arguments. Ignoring..."
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
\t dev                Start developling a new feature (alias: feature)
\t pull               Download changes from remote branch to local workspace
\t commit             Commit changes and push branch to remote (alias: checkpoint)
\t done               Commit changes and sync with remote
\t test               Runs test command defined in .gitstoryrc (alias: pre-commit)
\t switchto           Switch from current branch to specified branch (alias: branch, goto)
\t diff               List status and uncomitted changes
\t pull-request       Open current git repository on Github (alias: open, github)
\t package            Package the project. Runs `GS_PACKAGE` (alias: build)
\t history            List repository commits (alias: repo-history)
\t show               Show last or specified commit (alias: last)
\t status             Shows the current git status
\t where              Shows all available branches (alias: branches)
\t abort-merge        Aborts current merge (alias: abort_merge, abortmerge)
\t list               Prints command list
\t stash              Manage git-stash stack.
\t stat               Print statistics of git repository (alias: statistics)
\t get-update         Updates git-story"
}

__gs-ready-checklist-print() {
  __gs-warning "$GS_CHECKLIST_MESSAGE"
  echo ""
}
