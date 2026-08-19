# Troubleshooting
> Please be in your python virtual enviroment!

## Identifying buttons
```bash
ulanzi-manager debug
```

Press each button on your device. You'll see:
```
Button layout:
  0  1  2  3  4
  5  6  7  8  9
 10 11 12 13 (Clock/Big Button)

>>> BUTTON 0 PRESSED (index=0, state=0) <<<
>>> CLOCK PRESSED (index=13, state=0) <<<
```

**Note the index of each button you press.**

## Images Not Showing

> Icons are stored at ~/.config/ulanzi/icons/

1. **Validate your config to check image paths**:
   ```bash
   ulanzi-manager validate ~/.config/ulanzi/config.yaml
   ```

2. **Verify your image format**:
   - Must be PNG
   - Must be 196×196 pixels
   - RGB or RGBA color space

3. **Check logs**:
   ```bash
   tail -f ~/.local/share/ulanzi/daemon.log
   ```
    If you are using the systemd daemon:
   ```bash
   journalctl --user -u ulanzi-daemon -f
   ```

### Test with a Single Image
Test a single button with a known image:
```bash
ulanzi-manager test-image 0 ./icons/firefox.png --label "Test"
```

Check the logs to see if the image was sent:
```
DEBUG:ulanzi_manager.device:Added image for button 0: ./icons/firefox.png
```

## Device Not Found
``ERROR:ulanzi_manager.cli:Failed to connect: open failed``

1. **Install udev rules**
    ```bash
    sudo cp 99-ulanzi.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    ```

2. **Reconnect your Ulanzi D200 device via USB**
    
    Verify it's recognized:
    ```bash
    lsusb | grep 2207
    ```

    You should see:
    ```
    Bus 001 Device 005: ID 2207:0019 Fuzhou Rockchip Electronics Company
    ```
    If not:
    - Check USB cable connection
    - Try a different USB port
    - Try a different USB cable
    - Check if device is powered on

3. **Test Connection**
    ```bash
    ulanzi-manager status
    ```

    Expected output:
    ```
    INFO:ulanzi_manager.device:Connected to Ulanzi D200 device
    INFO:ulanzi_manager.cli:Device connected and ready
    ```

If you have installed the rules and is using the systemd daemon:
Debug and the daemon can NOT be executed at the same time!
```bash
systemctl --user stop ulanzi-daemon
```

## Keyboard shortcuts not working
```bash
sudo apt install xdotool
```

## OBS not connecting
1. Open OBS
2. Tools → WebSocket Server Settings
3. Enable WebSocket Server
4. Show Connect Info
5. Copy it into config

