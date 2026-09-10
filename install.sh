#!/bin/bash
# DPI Bypass - kurulum
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"

command -v spoofdpi >/dev/null || {
  echo "spoofdpi bulunamadi. Once kur:"
  echo "  brew install spoofdpi"
  echo "  (veya https://github.com/xvzc/SpoofDPI)"
  exit 1
}

echo "-> scriptler ~/.local/bin"
mkdir -p "$HOME/.local/bin"
install -m 755 "$REPO"/bin/dpi-bypass "$REPO"/bin/dpi-bypass-check "$REPO"/bin/dpi-bypass-toggle "$HOME/.local/bin/"

echo "-> LaunchAgents"
mkdir -p "$HOME/Library/LaunchAgents"
SPOOFDPI_BIN="$(command -v spoofdpi)"
sed -e "s#__HOME__#$HOME#g" -e "s#$HOME/.local/bin/spoofdpi#$SPOOFDPI_BIN#g" \
  "$REPO/launchagents/com.lng999.spoofdpi.plist" > "$HOME/Library/LaunchAgents/com.lng999.spoofdpi.plist"
cp "$REPO/launchagents/com.lng999.proxyenv.plist" "$HOME/Library/LaunchAgents/"

echo "-> DPI Bypass.app"
rm -rf "/Applications/DPI Bypass.app"
osacompile -o "/Applications/DPI Bypass.app" "$REPO/app/DPI Bypass.applescript"

echo
echo "Kurulum tamam."
echo "Acmak icin:  dpi-bypass on      (veya /Applications icindeki DPI Bypass.app)"
echo "PATH'te degilse: export PATH=\"\$HOME/.local/bin:\$PATH\""
