# discord-guard

Local Linux guardrail that blocks the Discord desktop app during configured night hours.

Current schedule:

- Blocks Monday to Thursday from 20:00 until 06:00 the next morning.
- Allows Friday night, Saturday and Sunday.
- Targets the installed Discord desktop app only, not Discord in the browser.

This is an autocontrol tool, not a security boundary. It runs without sudo and can be bypassed by a determined local user.

## Install

```bash
git clone https://github.com/Diogolima-creator/discord-guard.git
cd discord-guard
./install.sh
discord-guard setup-totp
```

Add the generated TOTP secret to an authenticator app or store it outside your daily workflow.

## Usage

```bash
discord-guard status
discord-guard status --json
discord-guard unlock
discord-guard enforce
```

Opening `discord` from the terminal or the GNOME launcher goes through `discord-guard launch`.

## Emergency Unlock

During blocked hours, `discord-guard` asks for a six-digit TOTP code. A valid code unlocks Discord until 06:00 of the current blocked window.

## Widgets

`discord-guard status --json` is intended as the stable integration point for future widgets. It returns:

- `scheduled_blocked`: whether the current time is inside the configured blocked schedule.
- `effective_blocked`: whether Discord is blocked after considering emergency unlocks.
- `next_change`: when the state changes next.
- `blocked_until`: when the active blocked window ends.
- `unlocked_until`: when an emergency unlock expires.

## Uninstall

```bash
./uninstall.sh
```

The uninstall script preserves `~/.config/discord-guard` and `~/.cache/discord-guard` so secrets and state are not deleted accidentally.
