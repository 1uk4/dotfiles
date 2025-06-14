#! /usr/bin/env bash
## Test Commit

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

setup_git(){
	bash ${DOTFILES}/installscripts/setup-git.sh
}

setup_hosts(){
	bash ${DOTFILES}/installscripts/setup-hosts.sh
}

setup_localenv(){
	bash ${DOTFILES}/installscripts/setup-localenv.sh
}


case "$1" in
    macos)
        setup_macos
        ;;
    brew)
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
    git)
	setup_git
	;;
    hosts)
	setup_hosts
	;;
    localenv)
	setup_localenv
	;;
    all)
	setup_macos
	setup_homebrew
	setup_link
	setup_terminfo
	setup_shell
	setup_hosts
	setup_git
	setup_localenv
        ;;
    *)
        echo -e $"\nUsage: $(basename "$0") {link|brew|shell|terminfo|macos|hosts|git|localenv|all}\n"
        exit 1
        ;;
esac

echo -e
success "Done."
