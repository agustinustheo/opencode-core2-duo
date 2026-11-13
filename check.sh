#!/usr/bin/env bash
# Start OpenCode and its background server through QEMU, and list models.
set -euo pipefail
opencode="$HOME/.opencode/bin/opencode"
echo "binfmt rule: $(head -1 /proc/sys/fs/binfmt_misc/opencode-qemu 2>/dev/null || echo missing)"
"$opencode" --version
"$opencode" service restart >/dev/null 2>&1 || true
# The first request after a cold start can time out under emulation.
for attempt in 1 2 3; do
  if output=$("$opencode" models 2>&1); then
    echo "$output" | head -20
    "$opencode" service status
    exit 0
  fi
  echo "Attempt $attempt failed. The server is possibly still starting." >&2
  sleep 10
done
echo "$output" >&2
exit 1
