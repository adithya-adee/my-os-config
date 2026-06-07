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
# Copy rather than symlink ssh config (avoids permission issues)
cp "$REPO/dotfiles/ssh_config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
ok "~/.ssh/config copied"

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
ok "~/.zshrc linked"

# ---------- 6. Scripts ----------
step "Installing personal scripts to ~/.local/bin"
mkdir -p "$HOME/.local/bin"

for script in assc.sh waydroid-internet.sh install_arcium.sh umbra-ceremony; do
  cp "$REPO/scripts/$script" "$HOME/.local/bin/$script"
  chmod +x "$HOME/.local/bin/$script"
  ok "~/.local/bin/$script installed"
done

# Also put assc.sh at ~/assc.sh (original location)
cp "$REPO/scripts/assc.sh" "$HOME/assc.sh"
chmod +x "$HOME/assc.sh"
ok "~/assc.sh installed"

# ---------- 7. GNOME settings ----------
step "Restoring GNOME dconf settings"
if command -v dconf &>/dev/null; then
  dconf load / < "$REPO/gnome-backup/full.backup"
  ok "GNOME settings restored"
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

# ---------- 9. Package lists (info only) ----------
step "Package lists reference"
echo "  Flatpak apps: $REPO/package-lists/flatpak-apps.txt"
echo "  Install with: xargs -a $REPO/package-lists/flatpak-apps.txt -I{} flatpak install flathub {}"
echo "  Cargo tools:  $REPO/package-lists/cargo-installs.txt"

echo -e "\n${GREEN}${BOLD}Bootstrap complete!${NC}"
