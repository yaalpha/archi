#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy configuration files
echo "Copying configuration files..."
BACKUP_DIR="$HOME/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

copy_with_backup() {
    local src=$1
    local dest=$2
    if [ -e "$dest" ]; then
        echo "Creating backup of $dest to $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR"
    fi
    cp -rf "$src" "$dest"
}

copy_with_backup "$SCRIPT_DIR/.config/" "$HOME/.config/"
copy_with_backup "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
copy_with_backup "$SCRIPT_DIR/wallpaper" "$HOME/wallpaper"
copy_with_backup "$SCRIPT_DIR/.themes/" "$HOME/.themes/"

# Enable multilib repository
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    if grep -q "^#\[multilib\]" /etc/pacman.conf; then
        sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    else
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    fi
    sudo pacman -Syu
fi

# Install yay if not present
if ! pacman -Q yay &>/dev/null; then
    echo "Installing yay..."
    sudo pacman -Syu --needed base-devel git
    git clone https://aur.archlinux.org/yay.git ~/yay
    (cd ~/yay && makepkg -si)
    rm -rf ~/yay
fi

# System update
echo "Updating system..."
yay -Syu --noconfirm

# Install main packages
echo "Installing main packages..."
yay -S --noconfirm \
    hyprland \
    waybar \
    waypaper \
    swww \
    rofi-wayland \
    swaync \
    wlogout \
    hyprshot \
    kitty \
    nemo \
    python-pipx \
    pavucontrol \
    fastfetch \
    zsh \
    starship \
    xcur2png \
    gsettings-qt \
    cursor-bin \
    github-desktop-bin \
    catnap \
    btop \
    cava \
    quich \
    gthumb \
    zen-browser-bin \
    networkmanager \
    networkmanager-qt \
    nm-connection-editor \
    pipewire \
    pipewire-pulse \
    wireplumber \
    gtk2 \
    gtk3 \
    nwg-look

# Install fonts
echo "Installing fonts..."
yay -S --noconfirm \
    ttf-dejavu \
    ttf-material-symbols-variable-git \
    ttf-jetbrains-mono-nerd \
    ttf-firacode-nerd \
    ttf-hack-nerd \
    ttf-roboto-mono-nerd \
    ttf-sourcecodepro-nerd \
    ttf-ubuntu-nerd \
    nerd-fonts-meta \
    ttf-fira-sans \
    otf-droid-nerd \
    texlive-fontsextra \
    ttf-droid \
    ttf-font-awesome \
    ttf-iosevka-nerd \
    adobe-source-sans-fonts \
    ttf-space-mono-nerd

# Update font cache
sudo fc-cache -fv

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Installation completed! Press Enter to reboot..."
read
reboot
