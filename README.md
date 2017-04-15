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
version: 0.0.1

command:
    new   |n      Create note
    list  |l      List note
    edit  |e      Edit note
    grep  |g      Grep note

options:
    --full-path   mm list [--full-path]

args:
    filename      mm new [filename]

customize by setting the following environment variable.
    _MM_POST_DIR=/Users/humangas/.config/mm/_posts
    _MM_TEMPLATE_FILE=
    _MM_PREFIX=
    _MM_EXTENSION=.md
```


## Dependencies software
- [fzf](https://github.com/junegunn/fzf)
- [fasd](https://github.com/clvv/fasd)
- [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher)
- [fileopener](https://github.com/humangas/fileopener)

### Installation
#### [fzf](https://github.com/junegunn/fzf#using-homebrew)
```
$ brew install fzf
/usr/local/opt/fzf/install
```

#### [fasd](https://github.com/clvv/fasd#install)
```
$ brew install fasd
echo 'eval "$(fasd --init auto)"' >> ~/.zshrc
```

#### [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher#macos)
```
$ brew install ag
```

#### [fileopener](https://github.com/humangas/fileopener#installation)
When installing this tool, it will be installed at the same time.


## Other stuff you might like
- [mattn/memo](https://github.com/mattn/memo)
