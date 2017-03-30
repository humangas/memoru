#!/usr/bin/env bash

MEMORU_POST_DIR=${MEMORU_POST_DIR:-~/.config/memo/_posts}
MEMORU_TEMPLATE_FILE=${MEMORU_TEMPLATE_FILE:-~/.config/memo/note.tpl}
MEMORU_TEMPLATE_HTML=${MEMORU_TEMPLATE_HTML:-~/.config/memo/html.tpl}
MEMORU_PREFIX=""
MEMORU_EXTENSION=".md"
MEMORU_SELECTCMD="fzf"
MEMORU_EDITOR="vim"
#MEMORU_SERVECMD="python -m SimpleHTTPServer"
#MEMORU_GREPCMD="ag ${MEMORU_PATTERN} ${MEMORU_POST_DIR}"
MEMORU_APPNAME="mmru"
MEMORU_VERSION="0.0.1"


function _version() {
    echo "$MEMORU_APPNAME $MEMORU_VERSION"
    exit 0
}

function _usage() {
echo "memoru command is a tool to conveniently write notes.

version: $MEMORU_VERSION

usage:  $MEMORU_APPNAME [--version] <command> [options] [args]

command:
        new   |n      Create note 
        list  |l      List note 
        edit  |e      Edit note 
        grep  |g      ENHANCEMENT
        delete|d      ENHANCEMENT
        serve |s      ENHANCEMENT
        build |b      ENHANCEMENT 

options:
        --full-path   memoru list [--full-path] 

args:
        filename      memoru new [filename]
        pattern       memoru grep [pattern]

customize by setting the following environment variable.
    MEMORU_POST_DIR=${MEMORU_POST_DIR}
    MEMORU_TEMPLATE_FILE=${MEMORU_TEMPLATE_FILE}
"
exit 1
}

function _new() {
    local title="$1"
    if [[ $# -eq 0 ]]; then
        printf "Title: "
        read -t 10 title
        [[ -z $title ]] && return 1
    fi

    fpath=$MEMORU_POST_DIR/$title$MEMORU_EXTENSION
    tmpl=$(cat ${MEMORU_TEMPLATE_FILE})
    echo $tmpl | sed -e "s/\${.Title}/${title}/g" > $fpath

    mkdir -p $MEMORU_POST_DIR
    vim "$fpath"
}

function _edit() {
    local target=$(ls -1 $MEMORU_POST_DIR)
    local select=$(printf "$target" | \
        fzf --cycle --preview "less -R $MEMORU_POST_DIR/{}" \
        --expect=enter,tab)

    key=$(echo $select | cut -d ' ' -f1)
    file=$(echo $select | cut -d ' ' -f2)

    _filesearch $key $file
}

function _filesearch() {
    local key=$1
    local file=$2

    case $key in
        enter)
            [[ $file =~ ^enter\s*$ ]] && return
            vim $MEMORU_POST_DIR/$file
            ;;
        tab)
            local line=$(ag -v '^\n' $MEMORU_POST_DIR/$file | fzf --expect=tab)
            [[ -z $line ]] && _edit && return
            [[ $line =~ ^tab\s*.* ]] && _edit && return
            local num=$(printf $line | cut -d: -f1)
            vim -c $num $MEMORU_POST_DIR/$file
            ;;
        *)
            return
            ;;
    esac
}

function _list() {
    local ls_option="-1"
    local stat_option="%w"
    # u access
    # t update
#    local header="Update              | FileName"
#    echo "Create              | Update              | Access              | FileName"

#    if [[ $# -gt 0 ]]; then
#        while getopts ":cuaf" opt
#        do
#            case $opt in
#                c) echo "1a"
#                   ;;
#                u) echo "2p"
#                   echo $OPTARG
#                   ;;
#                *) echo "3e" 
#                   echo $opt
#                   ;;
#            esac
#        done
#    fi

    if [[ "$1" == "--full-path" ]]; then
        for f in $(ls $ls_option $MEMORU_POST_DIR); do
            echo "$MEMORU_POST_DIR/$f"
        done
        exit 0
    fi

    #echo "$header"
    for f in $(ls $ls_option $MEMORU_POST_DIR); do
       #local fattr=$(stat -c "%w | %y | %x" $MEMORU_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       local fattr=$(stat -c "$stat_option" $MEMORU_POST_DIR/$f | sed -e 's/\.000000000 +0900//g')
       echo "$fattr | $f"
    done
}

function _grep() {
    echo "TODO: grep"
#    if [[ $inputPane -eq 1 ]]; then
#        printf "PANE: "
#        read -t 10 pane
#        case $pane in
#            U|D|L|R) ;;
#            ''|*) return 1 ;;
#        esac
#    fi
}

function _serve() {
    echo "TODO: serve"
    # tempdir でビルドして、trap時にはきする
    # 拡張子も重要 -> そうすると、md限定のほうがよさげ
    # build時に、法則が決まってないとむりだし
}

function _delete() {
    echo "TODO: delete"
}

function _build() {
    echo "TODO: build"
    # serveネタのHTMLをビルドする
    # こうなると、簡易的な静的サイトジェネレーターだな
}

function _param_check() {
    local _is_error=0

    if [[ ! -e $MEMORU_POST_DIR ]]; then
        _is_error=1
        echo "Error: \$MEMORU_POST_DIR is not found."
    fi 
    
    if [[ ! -e $MEMORU_TEMPLATE_FILE ]]; then
        _is_error=1
        echo "Error: \$MEMORU_TEMPLATE_FILE is not found."
    fi
    
    [[ $_is_error -eq 1 ]] && exit 1
    return
}

function main() {
    unset fzf
    unset LESS
    unset LESSOPEN

    [[ $# -eq 0 ]] && _usage
    [[ "$1" == "--version" ]] && _version
    
    _param_check

    subcmd="$1"
    shift

    case $subcmd in
        new|n)    _new "$@" && return ;;
        list|l)   _list "$@" && return ;;
        edit|e)   _edit "$@" && return ;;
        version)  _version ;;
        *)        _usage ;;
    esac
}

main "$@"
