#!/usr/bin/env bash
# Make the installed OpenCode run through QEMU. Run again after each OpenCode upgrade.
# Needs sudo one time, to register the binfmt_misc rule.
set -euo pipefail
root=$(dirname "$(readlink -f -- "${BASH_SOURCE[0]}")")
home_bin="$HOME/.opencode/bin"
libexec="$HOME/.opencode/libexec"
real="$libexec/opencode.ocqemu"
rule_name=opencode-qemu
rule=":$rule_name:E::ocqemu::$root/bin/opencode-qemu:"
conf="/etc/binfmt.d/$rule_name.conf"

[[ -x "$root/tools/qemu/usr/bin/qemu-x86_64" ]] || { echo "Missing QEMU. Run: bash $root/setup.sh" >&2; exit 1; }
[[ "$root" != *" "* ]] || { echo 'The repository path must not contain spaces.' >&2; exit 1; }

is_elf() { [[ -f "$1" ]] && [[ $(head -c 4 -- "$1" | od -An -c | tr -d ' ') == '177ELF' ]]; }

move_binary() {
  mkdir -p "$libexec"
  local found=""
  for candidate in "$home_bin/opencode" "$libexec/opencode"; do
    if is_elf "$candidate"; then found=$candidate; break; fi
  done
  if [[ -n "$found" ]]; then
    mv -f -- "$found" "$real"
    chmod +x "$real"
    echo "Moved $found to $real"
  elif [[ ! -f "$real" ]]; then
    echo "No OpenCode binary found. Install OpenCode first:" >&2
    echo "  curl -fsSL https://opencode.ai/v2/install | bash" >&2
    exit 1
  fi
}

write_launcher() {
  mkdir -p "$home_bin"
  cat > "$home_bin/opencode" <<LAUNCHER
#!/bin/sh
# Installed by opencode-core2-duo. The kernel runs this file through QEMU.
exec "$real" "\$@"
LAUNCHER
  chmod +x "$home_bin/opencode"
}

register_rule() {
  if [[ -f "$conf" ]] && [[ $(cat "$conf") == "$rule" ]] && [[ -e /proc/sys/fs/binfmt_misc/$rule_name ]]; then
    return
  fi
  echo "Registering binfmt_misc rule (sudo):"
  echo "  $rule"
  echo "$rule" | sudo tee "$conf" >/dev/null
  if [[ -e /proc/sys/fs/binfmt_misc/$rule_name ]]; then
    echo -1 | sudo tee "/proc/sys/fs/binfmt_misc/$rule_name" >/dev/null
  fi
  echo "$rule" | sudo tee /proc/sys/fs/binfmt_misc/register >/dev/null
}

move_binary
write_launcher
register_rule
"$home_bin/opencode" --version
echo 'OpenCode runs through QEMU.'
