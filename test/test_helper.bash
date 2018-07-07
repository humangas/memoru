#!/usr/bin/env bash

setup() {
    export NOTE_APPNAME="note"
    export NOTE_VERSION="0.3.1"
    export NOTE_POST_DIR="test/files"
    export NOTE_TEMPLATE_FILE=""
    export NOTE_PREFIX=""
    export NOTE_EXTENSION=".md"
    export NOTE_GREP_OPTIONS="--hidden --ignore .git/ . " 
    export NOTE_IGNORE_DIRS=""
}

debug_output() {
    printf '%s\n' 'output:' "$output" >&2
}

debug_env_all() {
    printf '%s\n' 'output:' \
      " NOTE_APPNAME:       $NOTE_APPNAME" \
      " NOTE_VERSION:       $NOTE_VERSION" \
      " NOTE_POST_DIR:      $NOTE_POST_DIR" \
      " NOTE_TEMPLATE_FILE: $NOTE_TEMPLATE_FILE" \
      " NOTE_PREFIX:        $NOTE_PREFIX" \
      " NOTE_EXTENSION:     $NOTE_EXTENSION" \
      " NOTE_GREP_OPTIONS:  $NOTE_GREP_OPTIONS" \
      " NOTE_IGNORE_DIRS:   $NOTE_IGNORE_DIRS" \
      >&2
}

debug_env() {
    printf '%s\n' 'output:' \
      " ENV:       $1" \
      >&2
}
