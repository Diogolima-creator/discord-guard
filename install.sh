#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -d "$HOME/.local/bin"
install -d "$HOME/.local/share/applications"
install -d "$HOME/.local/share/icons/hicolor/scalable/apps"
install -d "$HOME/.config/autostart"
install -d "$HOME/.config/systemd/user"
install -d "$HOME/.config/discord-guard"

install -m 0755 "$ROOT/bin/discord-guard" "$HOME/.local/bin/discord-guard"
install -m 0755 "$ROOT/bin/discord" "$HOME/.local/bin/discord"
install -m 0755 "$ROOT/bin/discord-guard-widget" "$HOME/.local/bin/discord-guard-widget"
install -m 0644 "$ROOT/assets/icons/discord-guard.svg" "$HOME/.local/share/icons/hicolor/scalable/apps/discord-guard.svg"

sed "s|@HOME@|$HOME|g" "$ROOT/desktop/discord.desktop.in" > "$HOME/.local/share/applications/discord.desktop"
sed "s|@HOME@|$HOME|g" "$ROOT/desktop/discord_discord.desktop.in" > "$HOME/.local/share/applications/discord_discord.desktop"
sed "s|@HOME@|$HOME|g" "$ROOT/desktop/discord-guard-widget.desktop.in" > "$HOME/.local/share/applications/discord-guard-widget.desktop"
cp "$HOME/.local/share/applications/discord-guard-widget.desktop" "$HOME/.config/autostart/discord-guard-widget.desktop"
chmod 0644 "$HOME/.local/share/applications/discord.desktop" "$HOME/.local/share/applications/discord_discord.desktop" "$HOME/.local/share/applications/discord-guard-widget.desktop" "$HOME/.config/autostart/discord-guard-widget.desktop"
chmod +x "$HOME/.config/autostart/discord-guard-widget.desktop" 2>/dev/null || true

sed "s|@HOME@|$HOME|g" "$ROOT/systemd/discord-timeblock.service.in" > "$HOME/.config/systemd/user/discord-timeblock.service"
install -m 0644 "$ROOT/systemd/discord-timeblock.timer" "$HOME/.config/systemd/user/discord-timeblock.timer"

if [ ! -f "$HOME/.config/discord-guard/config.json" ]; then
  cat > "$HOME/.config/discord-guard/config.json" <<'JSON'
{
  "start": "20:00",
  "end": "06:00",
  "days": ["mon", "tue", "wed", "thu"]
}
JSON
  chmod 0600 "$HOME/.config/discord-guard/config.json"
fi

systemctl --user daemon-reload
systemctl --user enable --now discord-timeblock.timer

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

echo "discord-guard instalado."
echo "Para configurar desbloqueio emergencial: discord-guard setup-totp"
echo "Para ver o estado atual: discord-guard status"
echo "Para abrir o widget: discord-guard-widget"
