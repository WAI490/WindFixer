# WindFixer

A small Windows batch script that removes two leftover Windscribe registry
keys so the app treats the machine as a fresh install.

> ⚠️ **Disclaimer:** This project is for **educational purposes only**.
> Using it may violate Windscribe's Terms of Service and could result in
> account or device restrictions. Use at your own risk. The author is not
> responsible for any damage, data loss, or account bans.

## What it does

Deletes these two keys under the **current user** hive (`HKCU`):

| # | Registry key |
|---|--------------|
| 1 | `HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort` |
| 2 | `HKCU\Software\Windscribe\Windscribe2` |

It also force-closes the Windscribe processes before deleting the keys.

## Requirements

- Windows 10 / 11
- Administrator rights (the script auto-elevates via UAC)
- Windscribe installed and **logged out** before running

## Usage

1. Log out of your Windscribe account.
2. Double-click `WindFixer.bat`.
3. Approve the UAC prompt **with the same Windows user that runs Windscribe**
   (otherwise `HKCU` points to a different user profile and nothing happens).
4. Wait for the script to finish.
5. Open Windscribe and sign in / create a new account.

## What it does *not* do

- It does **not** touch `HKLM` or system-wide settings.
- It does **not** create a backup — if you want one, export the keys manually:

```bat
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\NetControlPort" NetControlPort.reg
reg export "HKCU\Software\Windscribe\Windscribe2" Windscribe2.reg
```

## To restore:

```bat
reg import NetControlPort.reg
reg import Windscribe2.reg
```

## Notes

[NOT FOUND] messages are normal — the key may already be gone.

Verified on Windows 10/11 (22H2+). Tested with Windscribe desktop client.

## Credits

Based on the "Windscribe free VPN trick" video by Arka Labs.