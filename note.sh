#!/usr/bin/env bash

NOTE_APPNAME="note"
NOTE_VERSION="0.3.0"
NOTE_POST_DIR=${NOTE_POST_DIR:-~/note}
NOTE_TEMPLATE_FILE=${NOTE_TEMPLATE_FILE:-}
NOTE_PREFIX=${NOTE_PREFIX:-}
NOTE_EXTENSION=".md"
NOTE_GREP_OPTIONS=${NOTE_GREP_OPTIONS:-"--hidden --ignore .git/ . "} 


function _usage() {
echo "Usage: $NOTE_APPNAME [--version] <command> [<args>]
Version: $NOTE_VERSION

Command:
    new,n <title>           Create note
    list,l [--full-path]    List note
    edit,e [filter]         Edit note
    grep,g [filter]         Grep note
    finder,f                Open finder

Customize:
    export NOTE_POST_DIR=\"~/note\"
    export NOTE_TEMPLATE_FILE=\"\"
    export NOTE_PREFIX=\"\"
    export NOTE_EXTENSION=\".md\"
    export NOTE_GREP_OPTIONS=\"--hidden --ignore .git/ . \"

NOTICE:
    edit, grep function uses \"fzf\",\"ag\"
    - fzf: https://github.com/junegunn/fzf
    - ag: https://github.com/ggreer/the_silver_searcher 
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

    local filter=${1:-}
    local f=$(ag -g "$filter" $NOTE_POST_DIR \
        | sed -e "s@^$NOTE_POST_DIR/@@" \
        | fzf --preview "less -R $NOTE_POST_DIR/{}" \
        --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-y:yank
    )
    [[ -z $f ]] && return

    vim "$NOTE_POST_DIR/$f"
}

function _grep() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv

    local filter=${1:-.}
    local f=$(ag $filter $NOTE_GREP_OPTIONS $NOTE_POST_DIR \
            | sed -e "s@^$NOTE_POST_DIR/@@" \
            | fzf --tac --bind=ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-y:yank
    )
    [[ -z $f ]] && return

    local path=$(echo $f | cut -d: -f1)
    local lineno=$(echo $f | cut -d: -f2)
    vim -c $lineno "$NOTE_POST_DIR/$path" 
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
        find $NOTE_POST_DIR/* -type f
    else
        find $NOTE_POST_DIR/* -type f | sed s@$NOTE_POST_DIR/@@g
    fi

    exit 0
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
