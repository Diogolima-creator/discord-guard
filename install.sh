#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -d "$HOME/.local/bin"
install -d "$HOME/.local/share/applications"
install -d "$HOME/.config/systemd/user"

install -m 0755 "$ROOT/bin/discord-guard" "$HOME/.local/bin/discord-guard"
install -m 0755 "$ROOT/bin/discord" "$HOME/.local/bin/discord"

sed "s|@HOME@|$HOME|g" "$ROOT/desktop/discord.desktop.in" > "$HOME/.local/share/applications/discord.desktop"
sed "s|@HOME@|$HOME|g" "$ROOT/desktop/discord_discord.desktop.in" > "$HOME/.local/share/applications/discord_discord.desktop"
chmod 0644 "$HOME/.local/share/applications/discord.desktop" "$HOME/.local/share/applications/discord_discord.desktop"

sed "s|@HOME@|$HOME|g" "$ROOT/systemd/discord-timeblock.service.in" > "$HOME/.config/systemd/user/discord-timeblock.service"
install -m 0644 "$ROOT/systemd/discord-timeblock.timer" "$HOME/.config/systemd/user/discord-timeblock.timer"

systemctl --user daemon-reload
systemctl --user enable --now discord-timeblock.timer

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

echo "discord-guard instalado."
echo "Para configurar desbloqueio emergencial: discord-guard setup-totp"
echo "Para ver o estado atual: discord-guard status"
