#!/usr/bin/env bash
# update-zig is a script to easily fetch and install new Zig releases

set -o pipefail

me="${0##*/}"
version='0.1'

if [[ "$1" == '-v' ]]; then
	printf '%s: version: %s\n' "${me}" "${version}"
	exit 0
fi

base_url='https://ziglang.org/download'

latest="$(wget -qO- "${base_url}/index.json" | grep -v -E '[0-9\.]+-dev' | grep -E -o '[0-9]\.[0-9]+(\.[0-9]+)?' | uniq | head -n 1)"
if (( $? != 0 )); then
	printf '%s: could not find latest version\n' "${me}" >&2
	exit 1
fi

install_dir='/usr/local'
archive="zig-$(uname -s | tr "[:upper:]" "[:lower:]")-$(uname -m)-${latest}.tar.xz"
archive_path="${install_dir}/${archive}"
archive_url="${base_url}/${latest}/${archive}"

if ! wget -O "${archive_path}" "${archive_url}"; then
	printf '%s: could not download archive from: %s\n' "${me}" "${archive_url}" >&2
	exit 1
fi

if ! tar -C "${install_dir}" -xf "${archive_path}"; then
	printf '%s: could not extract archive: %s\n' "${me}" "${archive_path}" >&2
	exit 1
fi

zig_dir="${install_dir}/zig"
rm "${zig_dir}"

if ! ln -s "${archive_path%.tar.xz}" "${zig_dir}"; then
	printf '%s: could not relink zig directory: %s\n' "${me}" "${zig_dir}" >&2
	exit 1
fi

printf '\nHINT: Add Zig to your PATH enviroment variable\n\texport PATH=${PATH}:%s\n\n' "${zig_dir}"

exit 0
