#!/bin/bash

# Kanata installation script

set -e

echo "Installing kanata configuration..."

# Install kanata if not already installed
if ! command -v kanata &> /dev/null; then
    echo "Installing kanata..."
    if command -v brew &> /dev/null; then
        brew install kanata
    else
        echo "Please install kanata manually"
        exit 1
    fi
else
    echo "Kanata is already installed"
fi

# Check if user is in input group
if ! groups | grep -q "\binput\b"; then
    echo "Adding $USER to input group for device access..."
    sudo usermod -aG input "$USER"
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
ExecStart=/home/linuxbrew/.linuxbrew/bin/kanata -c $HOME/.config/kanata/kanata.kbd
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
echo "Kanata configuration: $HOME/.config/kanata/kanata.kbd"
echo "Service file: $HOME/.config/systemd/user/kanata.service"
echo ""
echo "Useful commands:"
echo "  systemctl --user status kanata    # Check status"
echo "  systemctl --user restart kanata   # Restart service"
echo "  systemctl --user stop kanata      # Stop service"
echo "  journalctl --user -u kanata -f    # View logs"