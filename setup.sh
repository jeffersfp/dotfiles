#! /usr/bin/env /bin/sh -e

# Program to install my dotfiles
# Github repo: https://github.com/jeffersfp/dotfiles

# set colors
RED='\033[31m'
YELLOW='\033[33m'
BOLD='\033[1m'
RESET='\033[m'

# usage: 
# log_msg "INFO" "This is info msg"
log_msg() {
	# timestamp format example 2020-03-21@14:53:53
	local TIMESTAMP=$(date +%F@%T)
	local LEVEL="${1}"
	local MESSAGE="${2}"
	case ${LEVEL} in
		"WARN") local COLOR=${YELLOW};;
		"ERROR") local COLOR=${RED};;
	esac
	echo "${BOLD}${COLOR}${TIMESTAMP} [${LEVEL}]: ${MESSAGE}${RESET}"
}

# usage:
# log_info "This is info msg"
log_info() {
	log_msg "INFO" "${1}"
}

# usage:
# log_warn "This is warn msg"
log_warn() {
	log_msg "WARN" "${1}"
}

# usage:
# log_err "This is err msg"
log_err() {
	log_msg "ERROR" "${1}"
}

ask_user_confirmation() {
	echo -n "${1} "
	read ANSWER
	echo "${ANSWER:-y}" | grep -qE "^y|Y|yes|YES$"
	return ${?}
}

# function to copy files and save a backup
# if the file already exists at destination
copy_file() {
	echo -n "Copy file: "
	/bin/cp --verbose --force --backup=numbered "${1}" "${2}"
}

# clone a github repo into a folder and 
# checkout to the latest release
install_from_github() {
	export PROJECT_REPO_URL="${1}"
	export PROJECT_DIR="${2}"
	(
		git clone "${PROJECT_REPO_URL}" "${PROJECT_DIR}"
		cd "${PROJECT_DIR}"
		git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
	)
}

setup_pyenv() {
	log_info "Setting up pyenv"
	install_from_github "https://github.com/pyenv/pyenv.git" "${HOME}/.pyenv"
}

setup_nvm() {
	log_info "Setting up nvm"
	install_from_github "https://github.com/nvm-sh/nvm.git" "${HOME}/.nvm"
}

setup_rbenv() {
	log_info "Setting up rbenv"
	install_from_github "https://github.com/rbenv/rbenv.git" "${HOME}/.rbenv"
}

setup_goenv() {
	log_info "Setting up goenv"
	install_from_github "https://github.com/syndbg/goenv.git" "${HOME}/.goenv"
}

setup_sdkman() {
	log_info "Setting up sdkman"
	sudo apt install -y zip unzip
	curl -s "https://get.sdkman.io?rcupdate=false" | bash
}

setup_zsh() {
	echo ""
	echo "${BOLD}####################${RESET}"
	echo "${BOLD}### ZSH DOTFILES ###${RESET}"
	echo "${BOLD}####################${RESET}"

	log_info "Installing pre-requisites for zsh"
	# TODO: make this works on all platforms (not only linux)
	sudo apt install -y curl zsh

	log_info "Setting up oh-my-zsh framework"
	curl -fsSL \
	  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		-o install_ohmyzsh.sh
	RUNZSH=no /bin/sh install_ohmyzsh.sh
	/bin/rm install_ohmyzsh.sh

	log_info "Setting up zsh dotfiles"
	copy_file "./zsh/.zshrc" "${HOME}/.zshrc"
	copy_file "./zsh/.zsh_aliases" "${HOME}/.zsh_aliases"
	copy_file "./zsh/jeff-fino.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes/jeff-fino.zsh-theme"

	# setup zsh-syntax-highlighting
	log_info "Setting up zsh-syntax-highlighting plugin"
	git clone \
		https://github.com/zsh-users/zsh-syntax-highlighting.git \
		${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	
	# setup zsh-autosuggestions
	log_info "Setting up zsh-autosuggestions plugin"
	git clone \
		https://github.com/zsh-users/zsh-autosuggestions \
		${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	ask_user_confirmation \
	  "${BOLD}Would you like to install pyenv (https://github.com/pyenv/pyenv)? [Y/n] ${RESET}" \
		&& setup_pyenv

	ask_user_confirmation \
	  "${BOLD}Would you like to install nvm (https://github.com/nvm-sh/nvm)? [Y/n] ${RESET}" \
	  && setup_nvm

	ask_user_confirmation \
		"${BOLD}Would you like to install rbenv (https://github.com/rbenv/rbenv)? [Y/n] ${RESET}" \
		&& setup_rbenv

	ask_user_confirmation \
		"${BOLD}Would you like to install goenv (https://github.com/syndbg/goenv)? [Y/n] ${RESET}" \
		&& setup_goenv

	ask_user_confirmation \
		"${BOLD}Would you like to install sdkman (https://sdkman.io/)? [Y/n] ${RESET}" \
		&& setup_sdkman

	log_info "Please restart the terminal emulator to apply the changes"
}

setup_vim() {
	echo ""
	echo "${BOLD}####################${RESET}"
	echo "${BOLD}### VIM DOTFILES ###${RESET}"
	echo "${BOLD}####################${RESET}"

	log_info "Installing pre-requisites for vim"
	# TODO: make this works on all platforms (not only linux)
	sudo apt install -y git exuberant-ctags ncurses-term curl

	# check if python and pip exists
	WHICH_PIP=$(command -v pip)
	if [ -n ${WHICH_PIP} ]; then
		log_info "Found pip at ${WHICH_PIP}. Installing pre-requisites for Python"
		${WHICH_PIP} install flake8 jedi
	fi

	log_info "Setting up vim dotfiles"
	copy_file "./vim/.vimrc" "${HOME}/.vimrc"

	log_info "Installing vim plugins"
	vim +PlugInstall +qall
}

### SETUP VSCODE ###
setup_vscode() {
	echo ""
	echo "${BOLD}#######################${RESET}"
	echo "${BOLD}### VSCODE DOTFILES ###${RESET}"
	echo "${BOLD}#######################${RESET}"

	# check for vscode existance
	VSCODE_EXISTS=$(command -v code)

	# detect operating system and copy settings.json file accordingly
	# https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
	case "$(uname)" in
		# TODO: implement win user dir
    # CYGWIN*)
    #     VSCODE_USER_DIR="%APPDATA%\Code\User";;
		Linux*)
				VSCODE_USER_DIR="${HOME}/.config/Code/User";;
    Darwin*)
        VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User";;
		"*")
  		log_warn "Could not determine operating system type."
			log_warn "This script only works on Linux and macOS."
			log_warn "VSCode dotfiles haven't been copied."
			;;
	esac

	if [ -n ${VSCODE_USER_DIR} -a -d ${VSCODE_USER_DIR} ]; then
		log_info "Setting up vscode dotfiles"
		copy_file "./vscode/settings.json" "${VSCODE_USER_DIR}/settings.json"
		copy_file "./vscode/.vscodestyles.css" "${VSCODE_USER_DIR}/.vscodestyles.css"
	else
		log_err "Invalid VSCode user dir: ${VSCODE_USER_DIR}"
		log_warn "VSCode dotfiles haven't been copied."
	fi
}

setup_zsh
setup_vim
setup_vscode

log_info "\nSetup complete :)"
