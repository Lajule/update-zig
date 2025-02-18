#!/usr/bin/env bash
# update-zig is a script to easily fetch and install new Zig releases

set -o pipefail

me="${0##*/}"
version=0.1
arch="$(uname -m)"
os="$(uname -s | tr "[:upper:]" "[:lower:]")"
base_url="https://ziglang.org/download"
install_dir="/usr/local"
latest=""
archive=""

find_latest() {
	latest="$(wget -qO- "${base_url}/index.json" | grep -v -E '[0-9\.]+-dev' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | uniq | head -n 1)"
	if (( $? != 0 )); then
		printf '%s: could not find latest version\n' "$me" >&2
		exit 1
	fi
}

download() {
	archive="${install_dir}/zig-${os}-${arch}-${latest}.tar.xz"
	local from
	from="${base_url}/${latest}/zig-${os}-${arch}-${latest}.tar.xz"
	if ! wget -O "${archive}" "${from}"; then
		printf '%s: could not download archive from: %s\n' "$me" "${from}" >&2
		exit 1
	fi
}

untar() {
	if ! tar -C "${install_dir}" -xf "${archive}"; then
		printf '%s: could not extract archive: %s\n' "$me" "${archive}" >&2
		exit 1
	fi
}

relink() {
	local zig_dir
	zig_dir="${install_dir}/zig"
	local new_zig_dir
	new_zig_dir="${install_dir}/zig-${os}-${arch}-${latest}"
	rm "${zig_dir}"
	ln -s "${new_zig_dir}" "${zig_dir}"
}

case "$1" in
	-v)
		printf '%s: version: %s\n' "$me" "${version}"
		exit 0;;
esac

find_latest
download
untar
relink

printf "\n"
printf "HINT: Add zig to your PATH enviroment variable\n"
printf "	export PATH=\${PATH}:%s\n" "${install_dir}/zig"
printf "\n"

exit 0
