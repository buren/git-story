#!/bin/bash

git config --global color.ui auto

###########
#  imports   #
###########
gs_folder="$HOME/.git-story/"

source $gs_folder/config.sh

source $gs_folder/src/cli/colors.sh
source $gs_folder/src/cli/cli.sh
source $gs_folder/src/cli/utils.sh

source $gs_folder/src/git/dev.sh
source $gs_folder/src/git/done.sh
source $gs_folder/src/git/messages.sh
source $gs_folder/src/git/proxy.sh
source $gs_folder/src/git/stats.sh

source $gs_folder/src/integration/integration.sh

###########
#  git-story   #
###########

__gs-read-config() {
  config_file="$(git rev-parse --show-toplevel)/.gitstoryrc"
  if [[ -f $config_file ]]; then
    source $config_file
  fi
}

__gs-update-source-help(){
  __gs-print "
usage:
\t gs get_update <brach_name>
updates git-story.
<branch_name> is optional and defaults to master.
alias: get-update, getupdate
"
}

__gs-update-source() {
  if [[ "$1" == "-help" ]] || [[ "$1" == "--help" ]]; then
    __gs-update-source-help
    return
  fi
  target=${1-master}
  __gs-print "Downloading latest changes made to 'git-story' from branch: '$target'"
  current_dir=$(pwd)
  cd $HOME/.git-story && __gs-pull $target
  cd $current_dir
  __gs-info "Successfully updated git-story."
}

