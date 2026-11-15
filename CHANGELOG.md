# Changelog

## 1.1.1 — 2026-11-15

- Documentation only — no change to the script's behaviour.
- Added the repository About description on GitHub.
- README (English and Persian): new "When do you need WindFixer?"
  section explaining the stuck sign-in / already-registered case the
  tool is for.
- `WindFixer.bat`: author credit line (by WAI490, with the repository
  link) added to the header comments and shown in yellow in the
  on-screen startup banner.

## 1.1.0 — 2026-11-14

- Added a real Y/N confirmation before anything is changed (previously
  the script only paused, so any keypress started the deletion).
- After elevating, the script now shows the current Windows user and
  profile path, so approving UAC with a different admin account is
  visible before anything happens.
- Honest per-key results: a key is only reported `[OK]` after a re-read
  confirms it is gone. A key that exists but cannot be deleted is now
  reported `[FAILED]` instead of `[NOT FOUND]`, appears in the final
  summary, and makes the script exit with code `1`.
- The script verifies Windscribe actually closed (one retry); if the
  app is still running it aborts and deletes nothing, instead of
  deleting keys the app could lock or recreate.
- Longer settle wait after killing the processes (1s → 3s).
- README: result/exit-code table, antivirus/SmartScreen note, and a
  Persian README (README-fa.md).
- No behaviour change to the core commands, and still no backup is
  created — by design; manual `reg export` commands remain in the
  README for anyone who wants one.

## 1.0.0 — 2026-11-13

- Initial release: deletes the two leftover Windscribe registry keys
  (`NetControlPort` and `Windscribe2`) under HKCU, with auto-elevation,
  Windscribe process shutdown, and per-key OK / NOT FOUND reporting.
