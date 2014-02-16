__install-git-story() {
  if [[ ! -d $HOME/.git-story/ ]]; then
    cd $HOME && git clone https://github.com/buren/git-story.git && mv git-story .git-story
  else
    echo "git-story already installed"
    echo "Exiting"
    return
  fi

  if [[ -f $HOME/.bash_profile ]]; then
    echo "Injecting import: bash_profile"
    cat $HOME/.git-story/setup/import.sh >> $HOME/.bash_profile
    source .bash_profile
  elif [[ -f $HOME/.bashrc ]]; then
    echo "Injecting import: bashrc"
    cat $HOME/.git-story/setup/import.sh >> $HOME/.bashrc
    source $HOME/.bashrc
  elif [[ -f $HOME/.zshrc ]]; then
    echo "Injecting import: zshrc"
    cat $HOME/.git-story/setup/import.sh >> $HOME/.zshrc
    source $HOME/.zshrc
  else
    echo "[ERROR] Neither .bash_profile, .bashrc or .zshrc found."
    echo ""
    echo -e "To install add the below line to your bash profile."
    echo -e "\t source ~/.git-story/setup/import.sh"
  fi
  echo "Importing to current shell"
  echo "Initialized"

}

__install-git-story
