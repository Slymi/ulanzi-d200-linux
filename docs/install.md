# Manual Installation Guide

## Prerequisites

- Python 3.10 or higher
- Linux system with USB support
- `xdotool` for keyboard shortcuts (optional but recommended)

## Step 1: Install System Dependencies

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv xdotool libhidapi-hidraw0
```

### Fedora/RHEL
```bash
sudo dnf install python3 python3-pip xdotool hidapi
```

### Arch
```bash
sudo pacman -S python python-pip xdotool hidapi
```

## Step 2: Clone and Create Python Virtual Enviroment

```bash
cd /path/to/ulanzi-d200-linux/
python3 -m venv ~/.local/ulanzi/venv
source ~/.local/ulanzi/venv/bin/activate
~/.local/ulanzi/venv/bin/pip install -e .
```

## Step 3: Install Udev Rule

```bash
sudo cp 99-ulanzi.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

## Step 4: Create Configuration Directory

```bash
mkdir -p ~/.config/ulanzi
mkdir -p ~/.local/share/ulanzi
mkdir -p ~/.local/bin
```

## Step 5: Generate Configuration

```bash
ulanzi-manager generate-config ~/.config/ulanzi/config.yaml
```

## Step 6: Edit Configuration

Edit `~/.config/ulanzi/config.yaml` with your button definitions and actions.

## Step 7: Test Configuration

```bash
ulanzi-manager validate ~/.config/ulanzi/config.yaml
```

## Step 8: Configure Device

```bash
ulanzi-manager configure ~/.config/ulanzi/config.yaml
```

## Step 9: Run Daemon

### Option A: Manual Start
> Must be inside virtual enviroment
```bash
ulanzi-daemon ~/.config/ulanzi/config.yaml
```

### Option B: Systemd Service (Recommended)

1. Create a simple wrapper that uses the venv:
```bash
cat > ~/.local/bin/ulanzi-daemon << 'WRAPPER'
#!/bin/bash
# Wrapper for ulanzi-daemon using ~/.local/ulanzi/venv
exec ~/.local/ulanzi/venv/bin/ulanzi-daemon "$@"
WRAPPER
```

2. Copy service file:
```bash
mkdir -p ~/.config/systemd/user
cp systemd/ulanzi-daemon.service ~/.config/systemd/user/
```

3. Enable and start:
```bash
systemctl --user daemon-reload
systemctl --user enable ulanzi-daemon
systemctl --user start ulanzi-daemon
```

4. Check status:
```bash
systemctl --user status ulanzi-daemon
```

5. View logs:
```bash
journalctl --user -u ulanzi-daemon -f
```

## Uninstall

```bash
# Disable systemd service (if using)
systemctl --user disable ulanzi-daemon
systemctl --user stop ulanzi-daemon
rm ~/.config/systemd/user/ulanzi-daemon.service

# Remove virtual environment
rm -rf ~/.local/ulanzi/venv

# Remove configuration
rm -rf ~/.config/ulanzi
rm -rf ~/.local/share/ulanzi
rm -f ~/.local/bin/ulanzi-daemon

# Delete udev rules
sudo rm /etc/udev/rules.d/99-ulanzi.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```
