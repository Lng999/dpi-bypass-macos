#!/bin/bash
# DPI Bypass - kaldirma
"$HOME/.local/bin/dpi-bypass" off 2>/dev/null || true
launchctl unload "$HOME/Library/LaunchAgents/com.lng999.spoofdpi.plist" 2>/dev/null || true
launchctl unload "$HOME/Library/LaunchAgents/com.lng999.proxyenv.plist" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.lng999.spoofdpi.plist" "$HOME/Library/LaunchAgents/com.lng999.proxyenv.plist"
rm -f "$HOME/.local/bin/dpi-bypass" "$HOME/.local/bin/dpi-bypass-check" "$HOME/.local/bin/dpi-bypass-toggle"
rm -rf "/Applications/DPI Bypass.app"
echo "Kaldirildi. (spoofdpi binary'si duruyor: brew uninstall spoofdpi)"
