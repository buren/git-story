if [[ ! -d ~/.git-story/ ]]; then
  cd ~ && git clone https://github.com/buren/git-story.git && mv git-story .git-story
else
  echo "git-story already installed"
  echo "Exiting"
  exit 0
fi

if [[ -f ~/.bash_profile ]]; then
  echo "Injecting import: bash_profile"
  cat ~/.git-story/setup/import.sh >> ~/.bash_profile
elif [[ -f ~/.bashrc ]]; then
  echo "Injecting import: bashrc"
  cat ~/.git-story/setup/import.sh >> ~/.bashrc
else
  echo "[ERROR] Neither .bash_profile or .bashrc present!"
  echo "However the script has been loaded and will be available in the current shell session."
  echo ""
  echo -e "To install add the below line to your bash profile."
  echo -e "\t source ~/.git-story/setup/import.sh"
fi
echo "Importing to current shell"
source ~/.git-story/setup/import.sh # Currently yields error
