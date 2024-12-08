#!/usr/bin/env bash

set -euxo pipefail

DOTDIR="$HOME/.dotfiles"

BLUE='\033[0;34m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
PINK='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

if [[ -n "${STOWMAN_DOTDIR}" ]]; then
    DOTDIR="${STOWMAN_DOTDIR}"
fi

stowcmd="stow -d $DOTDIR -t $HOME -v"
gitcmd="git -C $DOTDIR"

function push() {
    msg="$1"
    if [[ -z "$msg" ]]; then
        msg=$(eval "$gitcmd status --porcelain | awk '{print $2}' | cut -d'/' -f1-2 | sort -u | xargs")
    fi
    eval "$gitcmd add ."
    eval "$gitcmd commit -am '$msg'"
    eval "$gitcmd push"
}

function maybeCreateDir() {
    mkdir -p "$DOTDIR" 2>/dev/null
}

function init() {
    if [[ -z "$1" ]]; then
        usage
        return
    fi
    maybeCreateDir
    git clone "$1" "$DOTDIR"
}

function pull() {
    eval "$gitcmd pull"
}

function reload() {
    if [[ -z "$1" ]]; then
        usage
        return
    fi

    if [[ $1 = "all" ]]; then
        for i in "$DOTDIR"/*; do
            if [[ ! -d "$i" ]]; then continue; fi
            i="${i/$DOTDIR\/''/}"
            echo -e "Reloading ${BLUE}${i%%/}${NC}"
            eval "$stowcmd ${i%%/}"
        done
    else
        echo -e "Reloading ${BLUE}$1${NC}"
        eval "$stowcmd $1"
    fi
}

function add() {
    if [[ -z "$1" || -z "$2" ]]; then
        usage
        return
    fi

    src=$1
    pkg=$2

    if [[ ! -e "$DOTDIR" ]]; then
        echo -e "$DOTDIR ${RED}not found!${NC}. Please run ${BLUE}init${NC} first."
    fi

    if [[ "$src" = "." ]]; then
        src=$(pwd)
    fi

    if [[ "$src" != /* ]]; then
        src=$(pwd)/$src
    fi

    what=$src
    what=$(echo "$what" | sed -e "s/~\///g")
    what=$(echo "$what" | sed -e "s/\/home\/$(whoami)\///g")

    if [[ ! -e "$src" ]]; then
        echo
        echo -e "$src ${RED}not found!${NC}"
        return
    fi

    echo -e "${BLUE}From:\t${NC} $src"
    echo -e "${BLUE}To:\t${NC} $DOTDIR/${PINK}$pkg${NC}/$what"

    read -r -p "Continue [Y/n]" response
    if [[ "$response" =~ ^[Nn]$ ]]; then
        echo "Aborted."
    else
        if [[ ! -e "$DOTDIR/$pkg" ]]; then
            mkdir -p "$DOTDIR/$pkg"
        fi
        mv "$src" "$DOTDIR/$pkg/$what"
        eval "$stowcmd $pkg"
    fi

}

function usage() {
    echo -e "Invalid operation. Use stowman.sh ${PINK}--help${NC} for help."
}

function help() {
    cat <<EOF
   _==_ _
 _,(",)|_|
  \/. \-|   stowman.sh
__( :  )|_  Manage your dotfiles easily.

EOF

    gv=$(git --version 2>/dev/null)
    sv=$(stow --version 2>/dev/null)
    ddir="${GREEN}$DOTDIR${NC}"
    if [[ ! -e "$DOTDIR" ]]; then
        ddir="${RED}$DOTDIR not found${NC}"
    fi

    if [[ -z $gv ]]; then
        gv="${RED}not found"
    else
        gv=$(echo "$gv" | cut -d" " -f3)
    fi

    if [[ -z $sv ]]; then
        sv="${RED}not found"
    else
        sv=$(echo "$sv" | cut -d" " -f5)
    fi

    echo -e "git: \t${GREEN}$gv${NC}\tstow: \t${GREEN}$sv${NC} \t dots: ${ddir}"
    echo
    echo -e "${BLUE}Usage:${NC}"
    echo -e "stowman.sh ${PINK}init <repo>${NC}  \t${BLUE}Initialize a new config${NC}"
    echo -e "stowman.sh ${PINK}add <src> <pkg>${NC}  \t${BLUE}Adds a file/folder to a specific package${NC}"
    echo -e "stowman.sh ${PINK}reload <pkg>|all${NC} \t${BLUE}Applies changes to a specific package or all packages${NC}"
    echo -e "stowman.sh ${PINK}push${NC} \t\t${BLUE}Push changes to the repository${NC}"
    echo -e "stowman.sh ${PINK}pull${NC} \t\t${BLUE}Pull changes from the repository${NC}"
    echo
    echo -e "${BLUE}Initializing a new config${NC}"
    echo -e "stowman.sh ${PINK}init${NC} git@github.com:user/repo.git"
    echo
    echo -e "${BLUE}Adding new files or folders${NC}"
    echo -e "stowman.sh ${PINK}add${NC} ~/.config/nvim packagename"
    echo -e "stowman.sh ${PINK}add${NC} . packagename"
    echo
    echo -e "${BLUE}Reloading changes${NC}"
    echo -e "stowman.sh ${PINK}reload${NC} all"
    echo -e "stowman.sh ${PINK}reload${NC} packagename"
    echo
}

if [[ ! -e "$DOTDIR" ]]; then
    mkdir -p "$DOTDIR"
    echo -e "Created: ${YELLOW}$DOTDIR${NC}"
fi

case $1 in
add)
    add "$2" "$3"
    ;;
push)
    push "$2"
    ;;
pull)
    pull
    ;;
reload)
    reload "$2"
    ;;
init)
    init "$2"
    ;;
--help)
    help
    ;;
*)
    usage
    ;;
esac
