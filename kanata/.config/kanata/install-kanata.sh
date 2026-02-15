#!/bin/bash

# Kanata installation script (updated to use cmd-allowed version)

set -e

echo "Installing kanata configuration..."

# Use pre-installed binary by default (no interactive prompt)
REPLY="n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Building kanata from source..."
    if ! command -v cargo &> /dev/null; then
        echo "Cargo not found. Please install Rust first."
        exit 1
    fi
    rm -rf /tmp/kanata-build
    git clone https://github.com/jtroo/kanata.git /tmp/kanata-build || { echo "Failed to clone repo"; exit 1; }
    cd /tmp/kanata-build
    cargo build --release --features cmd
    mkdir -p "$HOME/.local/bin"
    cp target/release/kanata "$HOME/.local/bin/kanata"
    echo "Kanata built and installed to $HOME/.local/bin/kanata"
else
    # Copy cmd-allowed kanata binary
    echo "Copying cmd-allowed kanata binary..."
    mkdir -p "$HOME/.local/bin"
echo "Stopping kanata service if running..."
systemctl --user stop kanata.service || true
    cp "/home/simon/repos/dotfiles/kanata_cmd_allowed" "$HOME/.local/bin/kanata"
    chmod +x "$HOME/.local/bin/kanata"
    echo "Kanata binary installed to $HOME/.local/bin/kanata"
fi

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo "Adding ~/.local/bin to PATH..."
    export PATH="$HOME/.local/bin:$PATH"
    echo "NOTE: Add 'export PATH=\"$HOME/.local/bin:\$PATH\"' to your ~/.bashrc or ~/.zshrc"
fi

# Check if user is in input and uinput groups
missing_groups=()
if ! groups | grep -q "\binput\b"; then
    missing_groups+=("input")
fi
if ! groups | grep -q "\buinput\b"; then
    missing_groups+=("uinput")
fi

if [ ${#missing_groups[@]} -ne 0 ]; then
    echo "Adding $USER to groups: ${missing_groups[*]} for device access..."
    groups_str=$(IFS=,; echo "${missing_groups[*]}")
    sudo usermod -aG "$groups_str" "$USER"
    sudo udevadm control --reload-rules
    echo "IMPORTANT: You need to log out and back in for group changes to take effect!"
    echo "After logging back in, run this script again."
    exit 0
fi

# Udev rule already installed
echo "Udev rule already installed, skipping..."

# Create config directory
mkdir -p "$HOME/.config/kanata"

# Config is already in place via stow

# Create systemd user directory
mkdir -p "$HOME/.config/systemd/user"

# Generate systemd service file with correct paths
echo "Creating systemd service..."
cat > "$HOME/.config/systemd/user/kanata.service" << EOF
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata
After=graphical-session.target

[Service]
Type=simple
Environment=DISPLAY=:0
ExecStart=$HOME/.local/bin/kanata -c $HOME/.config/kanata/kanata.kbd
Restart=always
RestartSec=3

# Optional: For better performance
Nice=-20

[Install]
WantedBy=default.target
EOF

# Reload systemd daemon
echo "Reloading systemd..."
systemctl --user daemon-reload

# Enable and start the service
echo "Enabling kanata service..."
systemctl --user enable kanata.service

echo "Starting kanata service..."
systemctl --user start kanata.service

# Check service status
echo ""
echo "Checking service status..."
systemctl --user status kanata.service --no-pager

echo ""
echo "Installation complete!"
echo "Kanata binary: $HOME/.local/bin/kanata"
echo "Kanata configuration: $HOME/.config/kanata/kanata.kbd"
echo "Service file: $HOME/.config/systemd/user/kanata.service"
echo ""
echo "Useful commands:"
echo "  systemctl --user status kanata    # Check status"
echo "  systemctl --user restart kanata   # Restart service"
echo "  systemctl --user stop kanata      # Stop service"
echo "  journalctl --user -u kanata -f    # View logs"