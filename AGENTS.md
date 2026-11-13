# Agent instructions

- Read README.md before you make changes.
- This project is for OpenCode only. Do not add Claude Code files. Claude Code
  has its own project: claude-core2-duo.
- Use only Bash and the tools that `setup.sh` downloads.
- Keep downloaded files in `tools/`. Do not commit them.
- Do not put account data, API keys, or logs into Git.
- Do not change the shell configuration of the user.
- Keep each argument of the caller as one separate argument.
- Write short documentation in ASD-STE100 Simplified Technical English.
- Record known faults in `docs/troubleshooting.md`.
- After a change, run `./install.sh` and `./check.sh` on a Core 2 Duo system.
- Make a commit or a push only when the user tells you to.
- Do not add a `Co-Authored-By` line or other attribution line to a commit message.
