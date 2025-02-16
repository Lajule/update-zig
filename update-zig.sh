#!/usr/bin/env bash
#
# update-zig is a script to easily fetch and install new Zig releases
#
# Home: https://github.com/lajule/update-zig
#
# PIPETHIS_AUTHOR lajule

# ignore runtime environment variables
# shellcheck disable=SC2153
version=0.1

set -o pipefail

me=$(basename "$0")
msg() {
    echo >&2 "${me}": "$*"
}

debug() {
    [ -n "${DEBUG}" ] && msg debug: "$*"
}

log_stdin() {
    while read -r i; do
        msg "${i}"
    done
}

# defaults
msg "${me}"
