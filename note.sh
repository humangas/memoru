#!/usr/bin/env bash

NOTE_APPNAME="note"
NOTE_VERSION="0.2.0"
NOTE_POST_DIR=${NOTE_POST_DIR:-~/note}
NOTE_TEMPLATE_FILE=${NOTE_TEMPLATE_FILE:-}
NOTE_PREFIX=${NOTE_PREFIX:-}
NOTE_EXTENSION=".md"
NOTE_FILEOPENER="~/bin/fing"


function _usage() {
echo "Usage: $NOTE_APPNAME [--version] <command> [<args>]
Version: $NOTE_VERSION

Command:
    new <title>           Create note
    list [--full-path]    List note
    edit                  Edit note
    grep                  Grep note
    finder                Open finder

Customize:
    export NOTE_POST_DIR=\"~/note\"
    export NOTE_TEMPLATE_FILE=
    export NOTE_PREFIX=
    export NOTE_EXTENSION=\".md\"

NOTICE:
    edit, grep function uses the humangas/findgrep
    See also: https://github.com/humangas/findgrep
"
exit 0
}

function _version() {
    echo "$NOTE_APPNAME $NOTE_VERSION"
    exit 0
}

function _new() {
    local title="$1"
    if [[ $# -eq 0 ]]; then
        echo "Usage: $NOTE_APPNAME new <title>"
        return 1
    fi

    fpath=$NOTE_POST_DIR/$NOTE_PREFIX$title$NOTE_EXTENSION
    echo "$TMPL" | sed -e "s/\${.Title}/${title}/g" > $fpath

    mkdir -p $NOTE_POST_DIR
    vim "$fpath"
}

function _edit() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv
    eval "$NOTE_FILEOPENER" $NOTE_POST_DIR
}

function _grep() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv
    eval "$NOTE_FILEOPENER" $NOTE_POST_DIR --grep
}

function _finder() {
    open -a finder "$NOTE_POST_DIR"
    exit 0
}

function _list() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv

    local ls_option="-1"
    local stat_option="%w"

    if [[ "$1" == "--full-path" ]]; then
        for f in $(ls $ls_option $NOTE_POST_DIR); do
            echo "$NOTE_POST_DIR/$f"
        done
        exit 0
    fi

    #echo "$header"
    for f in $(ls $ls_option $NOTE_POST_DIR); do
       #local fattr=$(stat -c "%w | %y | %x" $NOTE_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       local fattr=$(stat -c "$stat_option" $NOTE_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       echo "$fattr | $f"
    done
}

function _check_file_exist() {
    local _is_error=0
    
    if [[ ! -e $NOTE_POST_DIR ]]; then
        _is_error=1
    elif [[ $(ls -1 $NOTE_POST_DIR | wc -l) -eq 0 ]]; then
        _is_error=1
    fi

    if [[ $_is_error -eq 1 ]]; then
        echo "Error: file is not found. under \$NOTE_POST_DIR."
        echo "-> Run: $NOTE_APPNAME new"
        return 1
    fi
}

function _param_check() {
    local _is_error=0

    [[ ! -e $NOTE_POST_DIR ]] && mkdir -p $NOTE_POST_DIR
    
    if [[ -z $NOTE_TEMPLATE_FILE ]]; then
        TMPL='# ${.Title}'
    elif [[ ! -e $NOTE_TEMPLATE_FILE ]]; then
        _is_error=1
        echo "Error: \$NOTE_TEMPLATE_FILE is not found."
    else
        TMPL=$(cat ${NOTE_TEMPLATE_FILE})
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
        new|n)     _new "$@" && return ;;
        list|l)    _list "$@" && return ;;
        edit|e)    _edit "$@" && return ;;
        grep|g)    _grep "$@" && return ;;
        finder|f)  _finder "$@" && return ;;
        version)   _version ;;
        *)         _usage ;;
    esac
}

main "$@"
