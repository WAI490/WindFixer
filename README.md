# WindFixer

**Version 1.1.1** · [README in Persian (فارسی)](README-fa.md)

A small Windows batch script that removes two leftover Windscribe registry
keys so the app treats the machine as a fresh install.

> **Disclaimer:** This project is for **educational purposes only**.
> Using it may violate Windscribe's Terms of Service and could result in
> account or device restrictions. Use at your own risk. The author is not
> responsible for any damage, data loss, or account bans.

## What it does

Deletes these two keys under the **current user** hive (`HKCU`):

| # | Registry key |
| --- | --- |
| 1 | `HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort` |
| 2 | `HKCU\Software\Windscribe\Windscribe2` |

It also force-closes the Windscribe processes before deleting the keys, and
verifies that Windscribe actually closed — if the app is still running, the
script aborts and deletes nothing.

## When do you need WindFixer?

Sometimes Windscribe gets stuck on a machine: it refuses to sign in or
keeps treating the PC as already registered, because two leftover keys
stay in the registry (`NetControlPort` and `Windscribe2` under HKCU).
When that happens, log out of Windscribe, run `WindFixer.bat`, confirm
with **Y**, and the script removes both keys (verifying each one) so
the client starts from a clean state again.

## Requirements

- Windows 10 / 11
- Administrator rights (the script auto-elevates via UAC)
- Windscribe installed and **logged out** before running

## Usage

1. Log out of your Windscribe account.
2. Double-click `WindFixer.bat`.
3. Approve the UAC prompt **with the same Windows user that runs
   Windscribe** (otherwise `HKCU` points to a different user profile and
   nothing happens). After elevating, the script shows the current Windows
   user and profile path — check they are yours.
4. Press **Y** to confirm, or **N** to cancel without changing anything.
5. Read the summary at the end, then open Windscribe and sign in / create a
   new account.

## Reading the result

Every key gets its own verified result — a key is only reported as deleted
after the script re-reads the registry and confirms it is gone:

| Message | Meaning |
| --- | --- |
| `[OK] ... deleted` | The key existed and was deleted and verified gone. |
| `[NOT FOUND] ... already clean` | The key was not there. This is normal. |
| `[FAILED] ... could not be deleted` | The key exists but could not be deleted (locked or access denied). This is **not** shown as NOT FOUND, the final summary lists it, and the script exits with code `1` instead of claiming success. |

Exit codes: `0` = done (or cancelled by you), `1` = aborted or finished
with errors.

## What it does *not* do

- It does **not** touch `HKLM` or system-wide settings.
- It does **not** create a backup — this is deliberate. If you want one,
  export the keys manually **before** running:

  ```
  reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort" NetControlPort.reg
  reg export "HKCU\Software\Windscribe\Windscribe2" Windscribe2.reg
  ```

## To restore:

```
reg import NetControlPort.reg
reg import Windscribe2.reg
```

(Only works if you exported the keys yourself first — see above.)

## Antivirus / SmartScreen note

This script asks for administrator rights, closes processes and deletes
registry keys, so some antivirus products or Windows SmartScreen may warn
about it. That reaction is expected for any tool of this kind. The script
is a single plain-text `.bat` file with no downloads and no network use —
read it in Notepad before running and only use the copy from this
repository.

## Notes

- `[NOT FOUND]` messages are normal — the key may already be gone.
- Verified on Windows 10/11 (22H2+). Tested with Windscribe desktop client.
- See [CHANGELOG.md](CHANGELOG.md) for what changed in each version.

## Credits

Based on the "Windscribe free VPN trick" video by Arka Labs.
