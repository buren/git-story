function __gs-error {
  echo -e "${BOLD}${MAGENTA}$1$WHITE"
}

function __gs-success {
  echo -e "${BOLD}${GREEN}$1$WHITE"
}

function __gs-warning {
  echo -e "${BOLD}${ORANGE}$1$WHITE"
}

function __gs-info {
  echo -e "${BOLD}${PURPLE}$1$WHITE"
}

function __gs-print {
  echo -e "${WHITE}$1$WHITE"
}

function __gs-ignore-args {
  __gs-error "
No arguements allowed for:
\t $PURPLE$1$WHITE
Ignoring arguments."
echo ""
}
