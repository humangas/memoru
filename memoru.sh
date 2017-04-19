#!/usr/bin/env bash

MM_APPNAME="mm"
MM_VERSION="0.0.1"
MM_POST_DIR=${MM_POST_DIR:-~/.config/$MM_APPNAME/_posts}
MM_TEMPLATE_FILE=${MM_TEMPLATE_FILE:-}
MM_PREFIX=${MM_PREFIX:-}
MM_EXTENSION=".md"
MM_FILEOPENER="/usr/local/bin/fo"


function _usage() {
echo "usage: $MM_APPNAME [--version] <command> [options] [args]
version: $MM_VERSION

command:
    new   ,n      Create note
    list  ,l      List note
    edit  ,e      Edit note
    grep  ,g      Grep note

options:
    --full-path   mm list [--full-path]

args:
    filename      mm new [filename]

customize by setting the following environment variable.
    MM_POST_DIR=/Users/humangas/.config/mm/_posts
    MM_TEMPLATE_FILE=
    MM_PREFIX=
    MM_EXTENSION=.md

NOTICE:
    edit, grep function uses the fileopener tool
    See also: https://github.com/humangas/fileopener
"
exit 0
}

function _version() {
    echo "$MM_APPNAME $MM_VERSION"
    exit 0
}

function _new() {
    local title="$1"
    if [[ $# -eq 0 ]]; then
        printf "Title: "
        read -t 10 title
        [[ -z $title ]] && return 1
    fi

    fpath=$MM_POST_DIR/$MM_PREFIX$title$MM_EXTENSION
    echo "$TMPL" | sed -e "s/\${.Title}/${title}/g" > $fpath

    mkdir -p $MM_POST_DIR
    vim "$fpath"
}

function _edit() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv
    eval "$MM_FILEOPENER" $MM_POST_DIR
}

function _grep() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv
    eval "$MM_FILEOPENER" $MM_POST_DIR --grep
}

function _list() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv

    local ls_option="-1"
    local stat_option="%w"

    if [[ "$1" == "--full-path" ]]; then
        for f in $(ls $ls_option $MM_POST_DIR); do
            echo "$MM_POST_DIR/$f"
        done
        exit 0
    fi

    #echo "$header"
    for f in $(ls $ls_option $MM_POST_DIR); do
       #local fattr=$(stat -c "%w | %y | %x" $MM_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       local fattr=$(stat -c "$stat_option" $MM_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       echo "$fattr | $f"
    done
}

function _check_file_exist() {
    local _is_error=0
    
    if [[ ! -e $MM_POST_DIR ]]; then
        _is_error=1
    elif [[ $(ls -1 $MM_POST_DIR | wc -l) -eq 0 ]]; then
        _is_error=1
    fi

    if [[ $_is_error -eq 1 ]]; then
        echo "Error: file is not found. under \$MM_POST_DIR."
        echo "-> Run: $MM_APPNAME new"
        return 1
    fi
}

function _param_check() {
    local _is_error=0

    [[ ! -e $MM_POST_DIR ]] && mkdir -p $MM_POST_DIR
    
    if [[ -z $MM_TEMPLATE_FILE ]]; then
        TMPL='# ${.Title}'
    elif [[ ! -e $MM_TEMPLATE_FILE ]]; then
        _is_error=1
        echo "Error: \$MM_TEMPLATE_FILE is not found."
    else
        TMPL=$(cat ${MM_TEMPLATE_FILE})
    fi
    
    [[ $_is_error -eq 1 ]] && exit 1
    return
}

function main() {
    [[ $# -eq 0 ]] && _usage
    [[ "$1" == "--version" ]] && _version
    
    _param_check

    local subcmd="$1"
    shift

    case $subcmd in
        new|n)    _new "$@" && return ;;
        list|l)   _list "$@" && return ;;
        edit|e)   _edit "$@" && return ;;
        grep|g)   _grep "$@" && return ;;
        version)  _version ;;
        *)        _usage ;;
    esac
}

main "$@"
