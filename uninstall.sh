#!/usr/bin/env bash
# Remove the binfmt_misc rule and put the native binary back.
set -euo pipefail
rule_name=opencode-qemu
real="$HOME/.opencode/libexec/opencode.ocqemu"
if [[ -e /proc/sys/fs/binfmt_misc/$rule_name ]]; then
  echo -1 | sudo tee "/proc/sys/fs/binfmt_misc/$rule_name" >/dev/null
fi
sudo rm -f "/etc/binfmt.d/$rule_name.conf"
if [[ -f "$real" ]]; then
  mv -f -- "$real" "$HOME/.opencode/bin/opencode"
fi
echo 'Removed. OpenCode runs natively again.'
