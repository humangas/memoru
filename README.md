# memoru
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
"memoru" is a command line tool to easily take notes from anywhere.


## Installation
```
$ git clone https://github.com/humangas/memoru.git
$ cd memoru
$ make install
```


## Usage
```
$ mm --help
usage: mm [--version] <command> [options] [args]
version: 0.1.0

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
```


## Dependencies software
- [fileopener](https://github.com/humangas/fileopener)


## Other stuff you might like
- [mattn/memo](https://github.com/mattn/memo)
