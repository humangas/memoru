#!/usr/bin/env bash

NOTE_APPNAME="note"
NOTE_VERSION="0.3.1"
NOTE_POST_DIR=${NOTE_POST_DIR:-~/note}
NOTE_TEMPLATE_FILE=${NOTE_TEMPLATE_FILE:-}
NOTE_PREFIX=${NOTE_PREFIX:-}
NOTE_EXTENSION=".md"
NOTE_GREP_OPTIONS=${NOTE_GREP_OPTIONS:-"--hidden --ignore .git/ . "} 
NOTE_IGNORE_DIRS=${NOTE_IGNORE_DIRS:-}

usage() {
echo "Usage: $NOTE_APPNAME [--version] <command> [<args>]
Version: $NOTE_VERSION

Command:
    new,n <title>           Create note
    list,l [--full-path]    List note
    edit,e [filter]         Edit note
    grep,g [filter]         Grep note
    finder,f                Open finder

Customize:
    export NOTE_POST_DIR=\"$NOTE_POST_DIR\"
    export NOTE_TEMPLATE_FILE=\"$NOTE_TEMPLATE_FILE\"
    export NOTE_PREFIX=\"$NOTE_PREFIX\"
    export NOTE_EXTENSION=\"$NOTE_EXTENSION\"
    export NOTE_GREP_OPTIONS=\"$NOTE_GREP_OPTIONS\"
    export NOTE_IGNORE_DIRS=\"$NOTE_IGNORE_DIRS\"

Dependencies:
    edit, grep function uses \"fzf\",\"ag\"
    - fzf: https://github.com/junegunn/fzf
    - ag:  https://github.com/ggreer/the_silver_searcher 
"
exit 0
}

version() {
    echo "$NOTE_APPNAME $NOTE_VERSION"
    exit 0
}

new() {
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

edit() {
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

grep_note() {
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

finder_note() {
    open -a finder "$NOTE_POST_DIR"
    exit 0
}

list() {
    _check_file_exist
    local retv=$?
    [[ $retv -eq 1 ]] && return $retv

    local ls_option="-1"
    local stat_option="%w"
    _ignore_dirs

    if [[ "$1" == "--full-path" ]]; then
        eval find $NOTE_POST_DIR/* $ignore_dirs_option -type f -print
    else
        eval find $NOTE_POST_DIR/* $ignore_dirs_option -type f -print | sed s@$NOTE_POST_DIR/@@g
    fi

    exit 0
}

_check_file_exist() {
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

_param_check() {
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

_ignore_dirs() {
    [[ -z "$NOTE_IGNORE_DIRS" ]] && return
    local _ignore_dirs_path
    for v in $NOTE_IGNORE_DIRS; do
        _ignore_dirs_path="$_ignore_dirs_path -path $NOTE_POST_DIR/$v -o"
    done
    ignore_dirs_option=" -type d \( ${_ignore_dirs_path%-o} \) -prune -o "
}

main() {
    [[ $# -eq 0 ]] && usage
    [[ "$1" == "--version" ]] && version
    
    _param_check

    local subcmd="$1"
    shift

    case $subcmd in
        new|n)     new "$@" && return ;;
        list|l)    list "$@" && return ;;
        edit|e)    edit "$@" && return ;;
        grep|g)    grep_note "$@" && return ;;
        finder|f)  finder_note "$@" && return ;;
        version)   version ;;
        *)         usage ;;
    esac
}

main "$@"
