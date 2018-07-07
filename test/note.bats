#!/usr/bin/env bats
########################################################
# Do the following in the repository's root directory
# $ make test
########################################################

load test_helper

@test "display version" {
    run ./note.sh version
    local version="$NOTE_APPNAME $NOTE_VERSION"
    [ $status -eq 0 ]
    [ "$output" == "$version" ]
}

@test "note list" {
    run ./note.sh list
    debug_output
    [ $status -eq 0 ]
    [ "${lines[0]}" == 'ignore1/test-003-ignore1.md' ]
    [ "${lines[1]}" == 'ignore1/test-004-ignore1.md' ]
    [ "${lines[2]}" == 'ignore2/test-001-ignore2.md' ]
    [ "${lines[3]}" == 'test-001.md' ]
    [ "${lines[4]}" == 'test-002.md' ]
    [ "${lines[5]}" == 'test-003.md' ]
}

@test "note list --full-path" {
    run ./note.sh list --full-path
    debug_env $NOTE_POST_DIR
    [ $status -eq 0 ]
    [ "${lines[0]}" == 'test/files/ignore1/test-003-ignore1.md' ]
    [ "${lines[1]}" == 'test/files/ignore1/test-004-ignore1.md' ]
    [ "${lines[2]}" == 'test/files/ignore2/test-001-ignore2.md' ]
    [ "${lines[3]}" == 'test/files/test-001.md' ]
    [ "${lines[4]}" == 'test/files/test-002.md' ]
    [ "${lines[5]}" == 'test/files/test-003.md' ]
}

@test "note list with NOTE_IGNORE_DIRS single option" {
    export NOTE_IGNORE_DIRS="ignore1"
    run ./note.sh list
    debug_env_all
    [ $status -eq 0 ]
    [ "${lines[0]}" == 'ignore2/test-001-ignore2.md' ]
    [ "${lines[1]}" == 'test-001.md' ]
    [ "${lines[2]}" == 'test-002.md' ]
    [ "${lines[3]}" == 'test-003.md' ]
}

@test "note list with NOTE_IGNORE_DIRS multiple option" {
    export NOTE_IGNORE_DIRS="ignore1 ignore2"
    run ./note.sh list
    debug_env_all
    [ $status -eq 0 ]
    [ "${lines[0]}" == 'test-001.md' ]
    [ "${lines[1]}" == 'test-002.md' ]
    [ "${lines[2]}" == 'test-003.md' ]
}
