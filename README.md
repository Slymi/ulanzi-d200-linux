# Ulanzi D200 Manager

A Linux application for managing the Ulanzi D200 StreamDeck device. Configure button images, labels, and actions to control OBS Studio, launch applications, execute commands, and more.

## Features

- 🎨 **Custom Button Images** - Set 196×196 PNG images for each button
- 🏷️ **Button Labels** - Add text labels to buttons with customizable styling
- 🎬 **OBS Integration** - Control OBS Studio scenes, sources, recording, and streaming
- 🚀 **App Launcher** - Launch applications with a button press
- ⌨️ **Keyboard Shortcuts** - Simulate keyboard input
- 💻 **Shell Commands** - Execute arbitrary shell commands
- 🔄 **Hot-Reload** - Update configuration without restarting
- 🌙 **Background Daemon** - Run as a systemd service

## Quick Start
### Automated install
1. **Install system dependencies:**
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

2. **Clone / Download repository into your user directory**

3. **Run the automated installer script:**
   ```bash
   sudo sh install.sh
   ```
   
4. **Edit configuration file:**
   > Example [here](examples/example_config.yaml)
   ```bash
   nano ~/.config/ulanzi/config.yaml
   ```
   
5. **Enter Python virtual enviroment:**
   > Ensure you use the appropriate activate script for your shell!
   ```bash
   source ~/.local/ulanzi/venv/bin/activate
   ```
   
6. **Validate your configuration:**
   ```bash
   ulanzi-manager validate ~/.config/ulanzi/config.yaml
   ```
   
7. **Configure the D200 device:**
   ```bash
   ulanzi-manager configure ~/.config/ulanzi/config.yaml
   ```
   
8. **Start daemon:**
   ```bash
   ulanzi-daemon ~/.config/ulanzi/config.yaml
   ```
9. **(Optional) Enable systemctl user service:**
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable ulanzi-daemon
   systemctl --user start ulanzi-daemon
   ```

## Image Preparation

Button images: PNG, 196×196 pixels, RGB/RGBA.

**Auto-generate icons** (recommended):
```yaml
buttons:
  - icon_spec:
      type: text
      color: '#FF6B00'
      text: "REC"
      text_color: '#FFFFFF'
      font_size: 70
    label: "Record"
    action: obs
    params:
      action: toggle_recording
```

See [docs/ICON_GENERATION.md](docs/ICON_GENERATION.md) for full icon spec options.
   
## Documentation
- [🔧 Manual Install Guide](docs/install.md)
- [🐛 Debug & Troubleshooting](docs/troubleshooting.md)
- [📋 Quick Reference](docs/quick_reference.md)
- [🎨 Icon Generation](docs/ICON_GENERATION.md)
- [🎬 OBS API Reference](docs/OBS_API_REFERENCE.md)
- [📦 Project Summary](docs/PROJECT_SUMMARY.md)

## Project Info
**License:** MIT

**References:**
- [Ulanzi D200 Protocol](https://github.com/redphx/strmdck)
- [OBS WebSocket](https://github.com/obsproject/obs-websocket)

---

*Yes, I vibecoded that and manually fixed some wrong stuff.*
