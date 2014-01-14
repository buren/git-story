__gs-error() {
  echo -e "${BOLD}${MAGENTA}$1$RESET"
}

__gs-success() {
  echo -e "${BOLD}${GREEN}$1$RESET"
}

__gs-warning() {
  echo -e "${BOLD}${ORANGE}$1$RESET"
}

__gs-info() {
  echo -e "${BOLD}${PURPLE}$1$WHITE"
}

__gs-print() {
  echo -e "${RESET}$1$RESET"
}

__gs-ignore-args() {
  __gs-error "
No arguements allowed for:
\t $PURPLE$1$RESET
Ignoring arguments."
echo ""
}
