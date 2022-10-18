#! /usr/bin/env bash

# Include Variables
source ./installscripts/shell-variables.sh


setup_link() {
	bash ${DOTFILES}/installscripts/setup-symlinks.sh
}

setup_homebrew() {
	bash ${DOTFILES}/installscripts/setup-homebrew.sh
}

setup_macos() {
	bash ${DOTFILES}/installscripts/setup-macos.sh
}

setup_terminfo() {
	bash ${DOTFILES}/installscripts/setup-terminfo.sh
}

setup_shell(){
	bash ${DOTFILES}/installscripts/setup-shell.sh
}


case "$1" in
    macos)
        setup_macos
        ;;
    homebrew)
	setup_homebrew
	;;
    link)
	setup_link
	;;
    terminfo)
	setup_terminfo
	;;
    shell)
	setup_shell
	;;
    all)
	setup_macos
	setup_homebrew
	setup_link
	setup_terminfo
	setup_shell
        ;;
    *)
        echo -e $"\nUsage: $(basename "$0") {backup|link|git|homebrew|shell|terminfo|macos|hostfiles|security|all}\n"
        exit 1
        ;;
esac

echo -e
success "Done."
