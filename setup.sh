#!/usr/bin/ bash

main() {
	# Ask for sudo
	ask_for_sudo
	# Login to app store
	login_to_app_store
	# Install xcode
	install_xcode
	# Install Homebrew
	install_homebrew
	# Change default shell to fish
	change_shell_to_fish
	# install oh my fish
	install_oh_my_fish
	# Powerline fonts
	install_powerline
	# Mackup restore
	mackup_restore
	# Set up VIM
	setup_vim
}

DOTFILES_REPO=~/Documents/GitHub/dotfiles

function ask_for_sudo() {
    info "Prompting for sudo password"
    if sudo --validate; then
        # Keep-alive
        while true; do sudo --non-interactive true; \
            sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo password updated"
    else
        error "Sudo password update failed"
        exit 1
    fi
}

function install_xcode() {
    xcode-select --install
}

function install_homebrew() {
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install mas
	cd $DOTFILES_REPO
	brew bundle
	cd ~
}

function change_shell_to_fish() {
    info "Fish shell setup"
    if grep --quiet fish <<< "$SHELL"; then
        success "Fish shell already exists"
    else
        user=$(whoami)
        substep "Adding Fish executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet \
            "/usr/local/bin/fish" /etc/shells; then
            substep "Fish executable already exists in /etc/shells"
        else
            if echo /usr/local/bin/fish | sudo tee -a /etc/shells > /dev/null;
            then
                substep "Fish executable successfully added to /etc/shells"
            else
                error "Failed to add Fish executable to /etc/shells"
                exit 1
            fi
        fi
        substep "Switching shell to Fish for \"${user}\""
        if sudo chsh -s /usr/local/bin/fish "$user"; then
            success "Fish shell successfully set for \"${user}\""
        else
            error "Please try setting Fish shell again"
        fi
    fi
}

function install_oh_my_fish {
	curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
	omf install agnoster
}

function install_powerline {
	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts
	./install.sh
	cd ..
	rm -rf fonts
}

function mackup_restore {
	mackup restore
}

function setup_vim() {
    info "Setting up vim"
    substep "Installing Vundle"
    if test -e ~/.vim/bundle/Vundle.vim; then
        substep "Vundle already exists"
        pull_latest ~/.vim/bundle/Vundle.vim
        substep "Pull successful in Vundle's repository"
    else
        url=https://github.com/VundleVim/Vundle.vim.git
        if git clone "$url" ~/.vim/bundle/Vundle.vim; then
            substep "Vundle installation succeeded"
        else
            error "Vundle installation failed"
            exit 1
        fi
    fi
    substep "Installing all plugins"
    if vim +PluginInstall +qall 2> /dev/null; then
        substep "Plugins installations succeeded"
    else
        error "Plugins installations failed"
        exit 1
    fi
    success "vim successfully setup"
}

main "$@"