#!/usr/bin/env bash
# update-zig is a script to easily fetch and install new Zig releases

set -o pipefail

version=0.1

arch="$(uname -m)"
os="$(uname -s | tr "[:upper:]" "[:lower:]")"

base="https://ziglang.org/download"
latest="$(wget -qO- "${base}/index.json" | grep -v -E '[0-9\.]+-dev' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | uniq | head -n 1)"

wget -O "zig-${os}-${arch}-${latest}.tar.xz" "${base}/${latest}/zig-${os}-${arch}-${latest}.tar.xz"
