#!/bin/bash
# bootstrap.sh — restore this machine's config on a fresh OS install
# Run from the repo root: bash bootstrap.sh

set -e
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

step() { echo -e "\n${CYAN}==> ${BOLD}$1${NC}"; }
ok()   { echo -e "  ${GREEN}✔${NC} $1"; }

# ---------- 1. Dotfiles ----------
step "Linking dotfiles"

ln -sf "$REPO/dotfiles/.gitconfig" "$HOME/.gitconfig"
ok ".gitconfig linked"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
cp "$REPO/dotfiles/ssh_config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
ok "~/.ssh/config copied"

cp "$REPO/dotfiles/mimeapps.list" "$HOME/.config/mimeapps.list"
ok "mimeapps.list copied"

if [ ! -f "$HOME/.wakatime.cfg" ]; then
  cp "$REPO/dotfiles/wakatime.cfg" "$HOME/.wakatime.cfg"
  echo "  ~/.wakatime.cfg copied — fill in api_key"
else
  ok "~/.wakatime.cfg already exists — skipping"
fi

# Solana CLI config
mkdir -p "$HOME/.config/solana/cli"
if [ ! -f "$HOME/.config/solana/cli/config.yml" ]; then
  cp "$REPO/dotfiles/solana-config.yml" "$HOME/.config/solana/cli/config.yml"
  ok "Solana CLI config copied"
else
  ok "Solana CLI config already exists — skipping"
fi

# ---------- 2. Neovim ----------
step "Linking Neovim config (nvim-pro)"
mkdir -p "$HOME/.config"
ln -sfn "$REPO/nvim-pro" "$HOME/.config/nvim"
ok "~/.config/nvim -> nvim-pro"

# ---------- 3. Kitty ----------
step "Linking Kitty config"
mkdir -p "$HOME/.config/kitty"
ln -sf "$REPO/terminal_backup/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "$REPO/terminal_backup/kitty/current-theme.conf" "$HOME/.config/kitty/current-theme.conf"
ok "~/.config/kitty linked"

# ---------- 4. Fastfetch ----------
step "Linking Fastfetch config"
mkdir -p "$HOME/.config/fastfetch"
ln -sf "$REPO/terminal_backup/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
ok "~/.config/fastfetch linked"

# ---------- 5. Zsh ----------
step "Linking .zshrc"
ln -sf "$REPO/terminal_backup/zsh/.zshrc" "$HOME/.zshrc"
ok "~/.zshrc linked (COLOSSEUM_COPILOT_PAT needs to be filled in)"

# ---------- 6. Scripts ----------
step "Installing personal scripts to ~/.local/bin"
mkdir -p "$HOME/.local/bin"

for script in assc.sh waydroid-internet.sh install_arcium.sh umbra-ceremony; do
  cp "$REPO/scripts/$script" "$HOME/.local/bin/$script"
  chmod +x "$HOME/.local/bin/$script"
  ok "~/.local/bin/$script installed"
done

cp "$REPO/scripts/assc.sh" "$HOME/assc.sh"
chmod +x "$HOME/assc.sh"
ok "~/assc.sh installed"

# ---------- 7. GNOME settings ----------
step "Restoring GNOME dconf settings"
if command -v dconf &>/dev/null; then
  dconf load / < "$REPO/gnome-backup/full.backup"
  ok "GNOME settings restored"
  dconf load /org/gnome/desktop/wm/keybindings/ < "$REPO/gnome-backup/keybinding-backup.dconf"
  ok "GNOME keybindings restored"
else
  echo "  dconf not found — skip (install gnome-shell first)"
fi

# ---------- 8. Rclone ----------
step "Rclone config"
if [ ! -f "$HOME/.config/rclone/rclone.conf" ]; then
  mkdir -p "$HOME/.config/rclone"
  cp "$REPO/rclone-backup/rclone.conf.template" "$HOME/.config/rclone/rclone.conf"
  echo "  Template copied to ~/.config/rclone/rclone.conf"
  echo "  Run: rclone config reconnect google-drive: && rclone config reconnect notes-crypt:"
else
  ok "rclone.conf already exists — skipping (won't overwrite)"
fi

# ---------- 9. VSCode ----------
step "VSCode settings"
if command -v code &>/dev/null; then
  mkdir -p "$HOME/.config/Code/User"
  cp "$REPO/vscode-backup/settings.json" "$HOME/.config/Code/User/settings.json"
  cp "$REPO/vscode-backup/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
  ok "VSCode settings and keybindings copied"
  echo "  Installing extensions..."
  xargs -a "$REPO/vscode-backup/extensions.txt" -I{} code --install-extension {} --force 2>/dev/null
  ok "VSCode extensions installed"
else
  echo "  code not in PATH — skipping VSCode setup"
fi

# ---------- 10. Cursor ----------
step "Cursor settings"
if command -v cursor &>/dev/null; then
  mkdir -p "$HOME/.config/Cursor/User"
  cp "$REPO/cursor-backup/settings.json" "$HOME/.config/Cursor/User/settings.json"
  cp "$REPO/cursor-backup/keybindings.json" "$HOME/.config/Cursor/User/keybindings.json"
  ok "Cursor settings and keybindings copied"
else
  echo "  cursor not in PATH — skipping Cursor setup"
fi

# ---------- 11. Systemd user units ----------
step "Systemd user units (sync-notes)"
mkdir -p "$HOME/.config/systemd/user"
cp "$REPO/systemd-backup/sync-notes.service" "$HOME/.config/systemd/user/"
cp "$REPO/systemd-backup/sync-notes.timer" "$HOME/.config/systemd/user/"
systemctl --user daemon-reload 2>/dev/null && systemctl --user enable --now sync-notes.timer 2>/dev/null \
  && ok "sync-notes.timer enabled" \
  || echo "  Could not enable timer — run: systemctl --user enable --now sync-notes.timer"

# ---------- 12. Autostart ----------
step "Autostart entries"
mkdir -p "$HOME/.config/autostart"
cp "$REPO/autostart-backup/"*.desktop "$HOME/.config/autostart/"
ok "Autostart desktop files copied"

# ---------- 13. Spicetify ----------
step "Spicetify config"
if command -v spicetify &>/dev/null; then
  mkdir -p "$HOME/.config/spicetify"
  cp "$REPO/spicetify-backup/config-xpui.ini" "$HOME/.config/spicetify/"
  ok "Spicetify config copied — run: spicetify apply"
else
  echo "  spicetify not installed — skipping"
fi

# ---------- 14. Package lists (info only) ----------
step "Package lists reference"
echo "  Flatpak:  xargs -a $REPO/package-lists/flatpak-apps.txt -I{} flatpak install flathub {}"
echo "  Cargo:    see $REPO/package-lists/cargo-installs.txt (reinstall manually)"
echo "  npm globals: xargs -a $REPO/package-lists/npm-globals.txt npm install -g"

echo -e "\n${GREEN}${BOLD}Bootstrap complete!${NC}"
echo "  Remaining manual steps:"
echo "  - Fill COLOSSEUM_COPILOT_PAT in ~/.zshrc"
echo "  - Fill WakaTime api_key in ~/.wakatime.cfg"
echo "  - Run: rclone config reconnect google-drive:"
echo "  - Reinstall oh-my-zsh + plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab, pure)"
