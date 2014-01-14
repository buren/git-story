__gs-error() {
  echo -e "${BOLD}${MAGENTA}$1$RESET"
}

__gs-success() {
  echo -e "${BOLD}${GREEN}$1$RESET"
}

__gs-warning() {
  echo -e "${BOLD}${ORANGE}$1$RESET"
}

<<<<<<< HEAD
function __gs-info {
  echo -e "${BOLD}${PURPLE}$1$WHITE"
}

function __gs-print {
  echo -e "${WHITE}$1$WHITE"
=======
__gs-print() {
  echo -e "${RESET}$1$RESET"
>>>>>>> c9b9962446cd471fc51434ef78dc2128bf736851
}

__gs-ignore-args() {
  __gs-error "
No arguements allowed for:
\t $PURPLE$1$RESET
Ignoring arguments."
echo ""
}
