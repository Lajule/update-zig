#!/usr/bin/env bash
# update-zig is a script to easily fetch and install new Zig releases

version=0.1

set -o pipefail

releases="https://ziglang.org/download/index.json"
arch="$(uname -m)"
os="$(uname -s | tr "[:upper:]" "[:lower:]")"
latest="$(wget -qO- "${releases}" | grep -v -E '[0-9\.]+-dev' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | uniq | head -n 1)"

msg "https://ziglang.org/download/${latest}/zig-${os}-${arch}-${latest}.tar.xz"

wget -O latest.tar https://ziglang.org/download/${latest}/zig-${os}-${arch}-${latest}.tar.xz
