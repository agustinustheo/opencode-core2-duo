# OpenCode Core 2 Duo Emulator

Run the official OpenCode 2 CLI on an older x86-64 Linux processor.
QEMU translates CPU instructions that the processor cannot execute.
The launcher does not change the OpenCode binary.

**Tested on an Intel Core 2 Duo P8600 with Linux Mint 22.3 and OpenCode 2.3.0.**
This CPU has no POPCNT, SSE4.2, AVX, or AVX2 support.
The official "baseline" build also stops with `Illegal instruction` on this CPU.

This project is separate from
[claude-core2-duo](https://github.com/agustinustheo/claude-core2-duo).
The two projects do not share files. You can install one, or both.

## How it works

OpenCode starts itself again as a background server (`opencode serve --service`).
A shell wrapper cannot catch that second start, because OpenCode runs its own
binary path directly. This project uses a Linux `binfmt_misc` rule instead:

1. `install.sh` moves the real binary to `~/.opencode/libexec/opencode.ocqemu`.
2. A `binfmt_misc` rule tells the kernel to run all `*.ocqemu` files with
   `bin/opencode-qemu`.
3. `bin/opencode-qemu` runs the file with `qemu-x86_64 -cpu max`.
4. `~/.opencode/bin/opencode` is a small launcher for the moved binary.

Each start of OpenCode, also the server that OpenCode starts, goes through QEMU.
The rule applies only to files with the `.ocqemu` extension.

## Install

Use Ubuntu 24.04 x86-64 or a derivative, with Bash, `apt-get`, `dpkg-deb`, and `sudo`.

1. Install OpenCode 2:

   ```bash
   curl -fsSL https://opencode.ai/v2/install | bash
   ```

   The installer adds `~/.opencode/bin` to your PATH. Do not use the default
   `https://opencode.ai/install` script. It installs OpenCode 1.

2. In this repository, run:

   ```bash
   bash setup.sh     # Downloads QEMU into tools/. No root.
   ./install.sh      # Needs sudo one time, for the binfmt_misc rule.
   ./check.sh        # Starts the server and lists the models.
   ```

The rule is kept in `/etc/binfmt.d/opencode-qemu.conf`, so it stays after a restart.

## Upgrade OpenCode

The launcher sets `OPENCODE_DISABLE_AUTOUPDATE=1`. Upgrade manually:

```bash
curl -fsSL https://opencode.ai/v2/install | bash
./install.sh
opencode service restart
```

`install.sh` finds the new native binary and moves it again.

## Remove

```bash
./uninstall.sh
```

## Known faults

See [docs/troubleshooting.md](docs/troubleshooting.md).
