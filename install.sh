#!/bin/bash
# Ulanzi D200 Manager Installation Script

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Ulanzi D200 Manager - Installation Script             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# Check if running from correct directory
if [ ! -f "setup.py" ]; then
    echo "✗ Error: setup.py not found. Run this script from the project root."
    exit 1
fi

# Step 1: Validate setup
echo "1. Validating setup..."
echo "   ✓ Ready to install"

# Step 2: Install udev rule
echo "2. Installing udev rule..."
if [ -w "/etc/udev/rules.d/" ]; then
    sudo cp 99-ulanzi.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    echo "   ✓ Udev rule installed"
else
    echo "   ⚠ Udev rule requires sudo. Run:"
    echo "     sudo cp 99-ulanzi.rules /etc/udev/rules.d/"
    echo "     sudo udevadm control --reload-rules"
    echo "     sudo udevadm trigger"
fi

# Step 3: Create config directories
echo "3. Creating configuration directories..."
mkdir -p /home/$SUDO_USER/.config/ulanzi/icons
cp icons/blank.png /home/$SUDO_USER/.config/ulanzi/icons/
mkdir -p /home/$SUDO_USER/.local/share/ulanzi
echo "   ✓ Directories created"

# Step 4: Setup /home/$SUDO_USER/.local/ulanzi with venv
echo "4. Setting up ~/.local/ulanzi with virtual environment..."
mkdir -p /home/$SUDO_USER/.local/ulanzi
mkdir -p /home/$SUDO_USER/.local/bin

# Create venv in /home/$SUDO_USER/.local/ulanzi
echo "   Creating virtual environment..."
python3 -m venv /home/$SUDO_USER/.local/ulanzi/venv

# Install package in the new venv
echo "   Installing package..."
/home/$SUDO_USER/.local/ulanzi/venv/bin/pip install -q -e .

# Create a simple wrapper that uses the venv
cat > /home/$SUDO_USER/.local/bin/ulanzi-daemon << 'WRAPPER'
#!/bin/bash
# Wrapper for ulanzi-daemon using ~/.local/ulanzi/venv
exec ~/.local/ulanzi/venv/bin/ulanzi-daemon "$@"
WRAPPER

chmod +x /home/$SUDO_USER/.local/bin/ulanzi-daemon
echo "   ✓ Virtual environment setup complete at ~/.local/ulanzi"
echo "   ✓ Wrapper script installed at ~/.local/bin/ulanzi-daemon"

# Step 5: Generate example config
echo "5. Generating example configuration..."
if [ ! -f /home/$SUDO_USER/.config/ulanzi/config.yaml ]; then
    /home/$SUDO_USER/.local/ulanzi/venv/bin/ulanzi-manager generate-config /home/$SUDO_USER/.config/ulanzi/config.yaml
    echo "   ✓ Configuration generated at ~/.config/ulanzi/config.yaml"
else
    echo "   ✓ Configuration already exists"
fi

# Step 6: Copy over systemd service file
echo "6. Copying systemd service file..."
if [ ! -f /home/$SUDO_USER/.config/systemd/user/ulanzi-daemon.service ]; then
    mkdir -p /home/$SUDO_USER/.config/systemd/user
    cp systemd/ulanzi-daemon.service /home/$SUDO_USER/.config/systemd/user/
    echo "   ✓ Systemd service file copied to ~/.config/systemd/user/ulanzi-daemon.service"
else
    echo "   ✓ Systemd Service file already exists"
fi

# Change ownership to the original user and their primary group
chown -R $SUDO_USER:$(id -gn $SUDO_USER) /home/$SUDO_USER/.config/ulanzi
chown -R $SUDO_USER:$(id -gn $SUDO_USER) /home/$SUDO_USER/.local/share/ulanzi
chown -R $SUDO_USER:$(id -gn $SUDO_USER) /home/$SUDO_USER/.local/ulanzi
chown -R $SUDO_USER:$(id -gn $SUDO_USER) /home/$SUDO_USER/.local/bin
chown -R $SUDO_USER:$(id -gn $SUDO_USER) /home/$SUDO_USER/.config/systemd/user

echo
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              ✓ Installation Complete!                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo
echo "Next steps:"
echo "1. Reconnect your Ulanzi D200 device (if not already connected)"
echo "2. Edit configuration: nano ~/.config/ulanzi/config.yaml"
echo "3. Enter venv: source ~/.local/ulanzi/venv/bin/activate (Select the appropriate activate script for your shell)"
echo "4. Validate: ulanzi-manager validate ~/.config/ulanzi/config.yaml"
echo "5. Configure device: ulanzi-manager configure ~/.config/ulanzi/config.yaml"
echo "6. Start daemon: ulanzi-daemon ~/.config/ulanzi/config.yaml"
echo
echo "Optional - Enable systemd user service:"
echo "  systemctl --user daemon-reload"
echo "  systemctl --user enable ulanzi-daemon"
echo "  systemctl --user start ulanzi-daemon"
echo
echo "For more info, see README.md or QUICKSTART.md"
echo
