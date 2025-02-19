#!/usr/bin/env bash
# update-zig is a script to easily fetch and install new Zig releases

set -o pipefail

me="${0##*/}"
version=0.1
arch="$(uname -m)"
os="$(uname -s | tr "[:upper:]" "[:lower:]")"
base_url="https://ziglang.org/download"
install_dir="/usr/local"
zig_dir="${install_dir}/zig"

if [[ "$1" == "-v" ]]; then
	printf '%s: version: %s\n' "$me" "${version}"
	exit 0
fi

latest="$(wget -qO- "${base_url}/index.json" | grep -v -E '[0-9\.]+-dev' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | uniq | head -n 1)"
if (( $? != 0 )); then
	printf '%s: could not find latest version\n' "$me" >&2
	exit 1
fi

archive="zig-${os}-${arch}-${latest}.tar.xz"
archive_path="${install_dir}/${archive}"
from_url="${base_url}/${latest}/${archive}"
if ! wget -O "${archive_path}" "${from_url}"; then
	printf '%s: could not download archive from: %s\n' "$me" "${from_url}" >&2
	exit 1
fi

if ! tar -C "${install_dir}" -xf "${archive_path}"; then
	printf '%s: could not extract archive: %s\n' "$me" "${archive_path}" >&2
	exit 1
fi

rm "${zig_dir}"
if ! ln -s "${archive_path%.tar.xz}" "${zig_dir}"; then
	printf '%s: could not relink zig directory: %s\n' "$me" "${zig_dir}" >&2
	exit 1
fi

printf "\n"
printf "HINT: Add zig to your PATH enviroment variable\n"
printf "	export PATH=\${PATH}:%s\n" "${zig_dir}"
printf "\n"

exit 0
