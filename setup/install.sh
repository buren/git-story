if [[ ! -d ~/.git-story/ ]]; then
  cd ~ && git clone https://github.com/buren/git-story.git && mv git-story .git-story
fi

if [[ -f ~/.bash_profile ]]; then
  cat ~/.git-story/setup/import.sh >> ~/.bash_profile
elif [[ -f ~/.bashrc ]]; then
  cat ~/.git-story/setup/import.sh >> ~/.bashrc
else
  echo "[ERROR] Neither .bash_profile or .bashrc present!"
  echo "However the script has been loaded and will be available in the current shell session."
  echo ""
  echo -e "To install add the below line to your bash profile."
  echo -e "\t source ~/.git-story/setup/import.sh"
fi
sh ~/.git-story/setup/import.sh
