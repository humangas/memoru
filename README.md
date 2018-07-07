# note
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)
[![Build Status](https://travis-ci.org/humangas/note.svg?branch=master)](https://travis-ci.org/humangas/note)  
"note" is a command line tool to easily take notes from anywhere.


## Installation
```
$ brew install --HEAD humangas/apps/note
```

### from source
```
$ git clone https://github.com/humangas/note.git
$ cd note
$ make install
```


## Usage
```
$ note --help
Usage: note [--version] <command> [<args>]
Version: 0.3.1

Command:
    new,n <title>           Create note
    list,l [--full-path]    List note
    edit,e [filter]         Edit note
    grep,g [filter]         Grep note
    finder,f                Open finder

Customize:
    export NOTE_POST_DIR="~/note"
    export NOTE_TEMPLATE_FILE=""
    export NOTE_PREFIX="%Y-%m-%d_"
    export NOTE_EXTENSION=".md"
    export NOTE_GREP_OPTIONS="--hidden --ignore .git/ . "
    export NOTE_IGNORE_DIRS=""

Dependencies:
    edit, grep function uses "fzf","ag"
    - fzf: https://github.com/junegunn/fzf
    - ag:  https://github.com/ggreer/the_silver_searcher 

```


## Dependencies software
- [junegunn/fzf](https://github.com/junegunn/fzf)
- [ag(ggreer/the_silver_searcher)](https://github.com/ggreer/the_silver_searcher)

