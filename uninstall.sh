#!/usr/bin/env bash
set -euo pipefail

systemctl --user disable --now discord-timeblock.timer >/dev/null 2>&1 || true
rm -f "$HOME/.config/systemd/user/discord-timeblock.service"
rm -f "$HOME/.config/systemd/user/discord-timeblock.timer"
systemctl --user daemon-reload >/dev/null 2>&1 || true

rm -f "$HOME/.local/bin/discord"
rm -f "$HOME/.local/bin/discord-guard"
rm -f "$HOME/.local/bin/discord-guard-widget"
rm -f "$HOME/.local/share/applications/discord.desktop"
rm -f "$HOME/.local/share/applications/discord_discord.desktop"
rm -f "$HOME/.local/share/applications/discord-guard-widget.desktop"
rm -f "$HOME/.config/autostart/discord-guard-widget.desktop"
rm -f "$HOME/.local/share/icons/hicolor/scalable/apps/discord-guard.svg"

echo "discord-guard removido. Segredos e estado em ~/.config/discord-guard e ~/.cache/discord-guard foram preservados."
