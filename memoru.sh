#!/usr/bin/env bash

_MM_APPNAME="mm"
_MM_VERSION="0.0.1"
_MM_POST_DIR=${_MM_POST_DIR:-~/.config/$_MM_APPNAME/_posts}
_MM_TEMPLATE_FILE=${_MM_TEMPLATE_FILE:-note.tpl}
_MM_PREFIX=""
_MM_EXTENSION=".md"


function _usage() {
echo "usage: $_MM_APPNAME [--version] <command> [options] [args]
version: $_MM_VERSION

command:
    new   |n      Create note 
    list  |l      List note 
    edit  |e      Edit note 
    grep  |g      Grep note 

options:
    --full-path   $_MM_APPNAME list [--full-path] 

args:
    filename      $_MM_APPNAME new [filename]

customize by setting the following environment variable.
    _MM_POST_DIR=${_MM_POST_DIR}
    _MM_TEMPLATE_FILE=${_MM_TEMPLATE_FILE}
    _MM_PREFIX=${_MM_PREFIX}
    _MM_EXTENSION=${_MM_EXTENSION}
"
exit 0
}

function _version() {
    echo "$_MM_APPNAME $_MM_VERSION"
    exit 0
}

function _new() {
    local title="$1"
    if [[ $# -eq 0 ]]; then
        printf "Title: "
        read -t 10 title
        [[ -z $title ]] && return 1
    fi

    fpath=$_MM_POST_DIR/$title$_MM_EXTENSION
    tmpl=$(cat ${_MM_TEMPLATE_FILE})
    echo $tmpl | sed -e "s/\${.Title}/${title}/g" > $fpath

    mkdir -p $_MM_POST_DIR
    vim "$fpath"
}

function _edit() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv
    ./fileopener.sh $_MM_POST_DIR
}

function _grep() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv
    ./fileopener.sh $_MM_POST_DIR --grep
}

function _list() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv

    local ls_option="-1"
    local stat_option="%w"

    if [[ "$1" == "--full-path" ]]; then
        for f in $(ls $ls_option $_MM_POST_DIR); do
            echo "$_MM_POST_DIR/$f"
        done
        exit 0
    fi

    #echo "$header"
    for f in $(ls $ls_option $_MM_POST_DIR); do
       #local fattr=$(stat -c "%w | %y | %x" $_MM_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       local fattr=$(stat -c "$stat_option" $_MM_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       echo "$fattr | $f"
    done
}

function _check_file_exist() {
    local _is_error=0
    
    if [[ ! -e $_MM_POST_DIR ]]; then
        _is_error=1
    elif [[ $(ls -1 $_MM_POST_DIR | wc -l) -eq 0 ]]; then
        _is_error=1
    fi

    if [[ $_is_error -eq 1 ]]; then
        echo "Error: file is not found. under \$_MM_POST_DIR."
        echo "-> Run: $_MM_APPNAME new"
        return 1
    fi
}

function _param_check() {
    local _is_error=0

    [[ ! -e $_MM_POST_DIR ]] && mkdir -p $_MM_POST_DIR
    
    if [[ ! -e $_MM_TEMPLATE_FILE ]]; then
        _is_error=1
        echo "Error: \$_MM_TEMPLATE_FILE is not found."
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
