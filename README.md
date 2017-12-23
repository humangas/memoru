# note
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
"note" is a command line tool to easily take notes from anywhere.


## Installation
```
$ brew install --HEAD humangas/apps/note
OR
$ git clone https://github.com/humangas/note.git
$ cd note
$ make install
```


## Usage
```
$ note --help
Usage: note [--version] <command> [options] [args]
version: 0.2.0

Command:
    new  <title>          Create note
    list [--full-path]    List note
    edit                  Edit note
    grep                  Grep note
    open                  Open finder

Customize:
    export NOTE_POST_DIR="~/note"
    export NOTE_TEMPLATE_FILE=
    export NOTE_PREFIX=
    export NOTE_EXTENSION=".md"

NOTICE:
    edit, grep function uses the humangas/fgopen
    See also: https://github.com/humangas/fgopen

```


## Dependencies software
- [humangas/fgopen](https://github.com/humangas/fgopen)


## Other stuff you might like
- [mattn/memo](https://github.com/mattn/memo)
