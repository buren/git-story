#!/bin/bash

git config --global color.ui auto

###########
#  imports   #
###########

source ~/.git-story/config.sh

source ~/.git-story/src/cli/colors.sh
source ~/.git-story/src/cli/cli.sh
source ~/.git-story/src/cli/utils.sh

source ~/.git-story/src/git/dev.sh
source ~/.git-story/src/git/done.sh
source ~/.git-story/src/git/messages.sh
source ~/.git-story/src/git/proxy.sh
source ~/.git-story/src/git/stats.sh

source ~/.git-story/src/integration/integration.sh

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
  elif [[ ! -z "$1" ]]; then
    __gs-print-args-ignored
  fi
  target=${2-master}
  __gs-print "Downloading latest changes made to 'git-story' from '$target'"
  current_dir=$(pwd)
  cd ~/.git-story && __gs-pull $target
  cd $current_dir
  __gs-info "Successfully updated git-story."
}

