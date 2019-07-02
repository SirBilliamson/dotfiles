#!/usr/bin/env bash

main() {
	# Sudo
	ask_for_sudo
	# Install Homebrew
	install_homebrew
	# Install MAS
	brew_install mas
	# Login to app store
	login_to_app_store
	# Clone Dotfiles
	clone_dotfiles_repo
	# Install all packages in Brewfile
	install_packages_with_brewfile
	# Change default shell to fish
	change_shell_to_fish
	# Configure git
	configure_git
	# Powerline-status for symlinks
	pip2_install powerline-status
	# Symlinks for vim
	setup_symlinks
	# Set up VIM
	setup_vim
	# Configure iTerm2
	configure_iterm2
	# MacOS defaults
	setup_macOS_defaults
}