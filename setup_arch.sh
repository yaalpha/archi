#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run script as root"
    exit 1
fi

# Logging function
log() {
    echo "==> $1"
}

# Enable multilib function
enable_multilib() {
    log "Enabling multilib repository..."
    
    # Check if multilib is already uncommented
    if grep -q "^#\[multilib\]" /etc/pacman.conf; then
        # Uncomment [multilib] and Include
        sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
        
        # Update package databases
        pacman -Sy --noconfirm
        
        log "Multilib repository enabled"
    else
        log "Multilib repository already enabled"
    fi
}

# Install yay function
install_yay() {
    log "Checking for yay..."
    if ! command -v yay &> /dev/null; then
        log "Installing yay..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    else
        log "yay already installed"
    fi
}

# System update function
update_system() {
    log "Updating system..."
    yay -Syu --noconfirm
}

# Package installation function
install_packages() {
    log "Installing packages..."
    
    # Main Hyprland components
    log "Installing Hyprland and main components..."
    yay -S --noconfirm \
        hyprland \
        waybar \
        waypaper \
        swww \
        rofi-wayland \
        swaync \
        wlogout \
        hyprshot

    # Terminal and file manager
    log "Installing terminal and file manager..."
    yay -S --noconfirm \
        kitty \
        nemo

    # Utils and tools
    log "Installing utilities..."
    yay -S --noconfirm \
        python-pipx \
        pavucontrol \
        fastfetch \
        zsh \
        xcur2png \
        gsettings-qt \
        cursor-bin \
        github-desktop-bin \
        catnap \
        btop \
        cava \
        quich

    # Browser
    log "Installing browser..."
    yay -S --noconfirm zen-browser-bin

    # Network tools
    log "Installing network tools..."
    yay -S --noconfirm \
        networkmanager \
        networkmanager-qt \
        nm-connection-editor

    # Audio components
    log "Installing audio components..."
    yay -S --noconfirm \
        pipewire \
        pipewire-pulse \
        wireplumber

    # Themes and appearance
    log "Installing themes and fonts..."
    yay -S --noconfirm \
        gtk2 \
        gtk3 \
        nwg-look \
        nerd-fonts-complete \
        ttf-fira-sans \
        ttf-firecode-nerd \
        otf-droid-nerd \
        texlive-fontsextra

    # Enable NetworkManager
    log "Activating NetworkManager..."
    systemctl enable NetworkManager
    systemctl start NetworkManager
}

# Oh My Zsh installation function
install_oh_my_zsh() {
    log "Installing Oh My Zsh..."
    
    # Check if Oh My Zsh is already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        # Install Oh My Zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Set zsh as default shell
        chsh -s $(which zsh) $USER
        
        log "Oh My Zsh successfully installed"
    else
        log "Oh My Zsh already installed"
    fi
}

# Config files installation function
install_configs() {
    log "Installing configuration files..."
    
    # Get script directory
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
    # Copy configuration files
    cp -rf "$SCRIPT_DIR/.config/" "$HOME/.config/"
    cp -f "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    cp -rf "$SCRIPT_DIR/wallpaper" "$HOME/wallpaper"
    cp -rf "$SCRIPT_DIR/.themes/" "$HOME/.themes/"
    
    log "Configuration files installed"
}

# Nerd Fonts installation function
install_nerd_fonts() {
    log "Installing Nerd Fonts..."
    
    yay -S --noconfirm \
        ttf-jetbrains-mono-nerd \
        ttf-firacode-nerd \
        ttf-hack-nerd \
        ttf-roboto-mono-nerd \
        ttf-sourcecodepro-nerd \
        ttf-ubuntu-nerd \
        nerd-fonts-meta
    
    # Update font cache
    fc-cache -fv
    
    log "Nerd Fonts installed"
}

# Main function
main() {
    log "Starting installation"
    
    enable_multilib
    install_yay
    update_system
    install_packages
    install_nerd_fonts
    install_oh_my_zsh
    install_configs
    
    log "Installation completed"
    
    # Reboot prompt
    read -p "Press Enter to reboot the system..."
    reboot
}

main 