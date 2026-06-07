# Manual installs

Things installed via curl or one-off scripts that aren't tracked by pacman/flatpak/pnpm/cargo.
On EndeavourOS, **check AUR first** — most of these have an AUR package now.

## Solana CLI
```bash
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
# Adds to PATH: ~/solana-release/bin
```
AUR alternative: `yay -S solana-bin`

## Arcium node (arcium CLI)
```bash
bash install_arcium.sh
# Script lives at scripts/install_arcium.sh in this repo
```

## Miniforge / Conda
```bash
curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
```
AUR alternative: `yay -S miniforge3`

## NVM (Node Version Manager)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```
AUR alternative: `yay -S nvm` (then `source /usr/share/nvm/init-nvm.sh`)

## Bun
```bash
curl -fsSL https://bun.sh/install | bash
```
AUR alternative: `yay -S bun-bin`

## Spicetify
```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```
AUR alternative: `yay -S spicetify-cli`

## Waydroid
```bash
# On EndeavourOS use AUR:
yay -S waydroid
sudo waydroid init
```

## OpenTabletDriver
AUR: `yay -S opentabletdriver`

## JetBrains Toolbox
AUR: `yay -S jetbrains-toolbox`

## Cloudflare WARP
AUR: `yay -S cloudflare-warp-bin`

## DFX (Internet Computer SDK)
```bash
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
```
No AUR package — install via curl only.

## Genymotion
Download from https://www.genymotion.com/product-desktop/
AUR: `yay -S genymotion`
