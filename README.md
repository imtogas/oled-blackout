# OLED Blackout

A lightweight Windows system tray application that puts a pure black (#000000) overlay on **all monitors** while keeping displays powered on.

## Quick start
1. Open **Actions** > **Build Windows EXE** > latest successful run.
2. Download the **OLED-Blackout-Windows** artifact and unzip it.
3. Move `OLED-Blackout.exe` into a permanent folder (for example `%LOCALAPPDATA%\OLEDBlackout`) and run it once.
4. Press **Ctrl + Alt + B** to toggle blackout. Press **Esc** to restore.

The application automatically adds itself to the current user's Windows Startup folder the first time it runs. It stays in the system tray; right-click its icon to disable startup, exit, or change the hotkey.

The hotkey setting is stored in `%APPDATA%\OLEDBlackout\settings.ini` and can be edited using AutoHotkey v2 hotkey notation.

**Notes:** Some exclusive fullscreen games and secure desktops cannot be covered. The startup entry runs after Windows login. OLED panels still need their built-in pixel care features. This is an overlay, not display power management.

## Building locally
Install AutoHotkey v2 and Ahk2Exe, then compile `OLEDBlackout.ahk`. GitHub Actions also builds an EXE on every push to main.

## Uninstall
Uncheck **Start with Windows** in the tray menu, exit, then delete the executable.

MIT License.
