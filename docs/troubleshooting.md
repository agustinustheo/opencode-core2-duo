# Troubleshooting

## `Illegal instruction` or `Server process terminated by SIGILL`

The native binary started without QEMU.

- Run `./install.sh` again. An OpenCode upgrade puts a native binary in
  `~/.opencode/bin/opencode`.
- Make sure that the rule is enabled:
  `cat /proc/sys/fs/binfmt_misc/opencode-qemu`.
- If you moved this repository, run `./install.sh` again. The rule contains
  the full path of `bin/opencode-qemu`.

## `Location plugins did not finish activating`

The first request after a cold server start can time out under emulation.
Wait some seconds and do the command again. The server continues to run in the
background, so the next requests are faster.

## OpenCode is slow

QEMU translates each instruction. A cold start takes approximately 5 seconds
on a Core 2 Duo P8600. Keep the background server running.
