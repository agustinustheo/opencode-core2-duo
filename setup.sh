#!/usr/bin/env bash
# Ubuntu 24.04 amd64 and derivatives: extract QEMU into tools/, without root.
set -euo pipefail
root=$(dirname "$(readlink -f -- "${BASH_SOURCE[0]}")")
[[ $(uname -s) == Linux && $(uname -m) == x86_64 ]] || { echo 'Requires x86_64 Linux.' >&2; exit 1; }
for command in apt-get dpkg-deb; do
  command -v "$command" >/dev/null || { echo "Missing dependency: $command" >&2; exit 1; }
done
mkdir -p "$root/tools"
scratch=$(mktemp -d "$root/tools/.download-XXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
cd "$scratch"
apt-get download qemu-user
dpkg-deb -x qemu-user_*.deb extracted
extracted/usr/bin/qemu-x86_64 --version
rm -rf "$root/tools/qemu"
mkdir -p "$root/tools/qemu"
cp -a extracted/. "$root/tools/qemu/"
echo 'Local QEMU ready.'
