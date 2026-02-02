#!/usr/bin/env bash
set -euo pipefail

# -------------------------------
# Osaka '09 Firefox Theme Installer
# -------------------------------

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"

FF_BASE="$HOME/.mozilla/firefox"

PROFILE="$(find "$FF_BASE" -maxdepth 1 -type d -name '*.default-release' | head -n1)"

if [ -z "$PROFILE" ]; then
    echo "Error: No default Firefox profile found." >&2
    exit 1
fi

CHROME="$PROFILE/chrome"
mkdir -p "$CHROME"

if [ -f "$CHROME/userChrome.css" ]; then
    BACKUP="$CHROME/userChrome.css.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing userChrome.css to $BACKUP"
    mv "$CHROME/userChrome.css" "$BACKUP"
fi

if [ -d "$THEME_DIR/chrome" ]; then
    echo "Copying Osaka '09 theme files to $CHROME"
    cp -r "$THEME_DIR/chrome/"* "$CHROME/"
else
    echo "Error: Theme files not found in $THEME_DIR/chrome" >&2
    exit 1
fi

if [ ! -f "$CHROME/userChrome.css" ]; then
    FIRST_CSS="$(find "$CHROME" -maxdepth 1 -type f -name '*.css' | head -n1)"
    if [ -n "$FIRST_CSS" ]; then
        ln -s "$(basename "$FIRST_CSS")" "$CHROME/userChrome.css"
        echo "Created symlink userChrome.css → $(basename "$FIRST_CSS")"
    else
        echo "Warning: No CSS files found to link as userChrome.css"
    fi
fi

echo "Osaka '09 Firefox CSS installed successfully."
echo "Remember to enable 'toolkit.legacyUserProfileCustomizations.stylesheets' in about:config."
