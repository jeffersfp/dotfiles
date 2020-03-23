#! /bin/zsh

DATE_FMT='%F@%T'
COLOR_RED='\e[1;31m'
COLOR_YELLOW='\e[33m'
COLOR_GREEN='\e[32m'
COLOR_RESET='\e[0m'

function log_msg {
  local TIMESTAMP
}

function log {
  local LEVEL=${0}
  
  local NOW=$(date +${DATE_FMT})
  echo -e "${COLOR_RED}${NOW} [ERROR] This is red text${COLOR_RESET}"
}

function log_error {
}

function log_warn {
  local NOW=$(date +${DATE_FMT})
  echo -e "${COLOR_YELLOW}${NOW} [ERR] This is red text${COLOR_RESET}"
}

function log_info {
  local NOW=$(date +${DATE_FMT})
  echo -e "${COLOR_GREEN}${NOW} [INFO] This is red text${COLOR_RESET}"
}


# cd into this script dir so all cp commands
# can use relative paths with the premisse
# that the current workdir is the script basedir
function cd_scriptdir {
  THIS_SCRIPT_DIR=$(dirname ${0})
  cd ${THIS_SCRIPT_DIR}
}

# function to help syncing zsh dotfiles
function sync_zsh {
  echo "Syncing ZSH files"
  local FILES_TO_SYNC=(
    "~/.zshrc"
    "~/.zsh_aliases"
    "~/.oh-my-zsh/custom/themes/jeff-fino.zsh-theme"
  )
  # iterate over files list and sync them
  # from their locations to the ./zsh folder
  for FILE in ${FILES_TO_SYNC}
  do

    rsync -av ${FILE} ./zsh/
  done
}

# start
cd_scriptdir
sync_zsh
