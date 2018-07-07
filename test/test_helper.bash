#!/usr/bin/env bash

setup() {
    _export_env
    export _TEST_TMPDIR="test/files"
    _make_testfiles
}

_export_env() {
    export NOTE_APPNAME="note"
    export NOTE_VERSION="0.3.1"
    export NOTE_POST_DIR="test/files"
    export NOTE_TEMPLATE_FILE=""
    export NOTE_PREFIX=""
    export NOTE_EXTENSION=".md"
    export NOTE_GREP_OPTIONS="--hidden --ignore .git/ . " 
    export NOTE_IGNORE_DIRS=""
}

_make_testfiles() {
    mkdir -p "$_TEST_TMPDIR/ignore1" "$_TEST_TMPDIR/ignore2"
    touch "$_TEST_TMPDIR/test-001.md"
    touch "$_TEST_TMPDIR/test-002.md"
    touch "$_TEST_TMPDIR/test-003.md"
    touch "$_TEST_TMPDIR/ignore1/test-003-ignore1.md"
    touch "$_TEST_TMPDIR/ignore1/test-004-ignore1.md"
    touch "$_TEST_TMPDIR/ignore2/test-001-ignore2.md"
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

teardown() {
    rm -rf "$_TEST_TMPDIR"
}
