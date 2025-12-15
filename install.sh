#!/usr/bin/env bash
set -e

THEME_DIR="$(cd "$(dirname "$0")" && pwd)"
FF_BASE="$HOME/.mozilla/firefox"
PROFILE="$(find "$FF_BASE" -maxdepth 1 -type d -name '*.default-release' | head -n1)"

if [ -z "$PROFILE" ]; then
    echo "No default Firefox profile found."
    exit 1
fi

CHROME="$PROFILE/chrome"
mkdir -p "$CHROME"

# backup existing userChrome.css
[ -f "$CHROME/userChrome.css" ] && mv "$CHROME/userChrome.css" "$CHROME/userChrome.css.bak"

# copy NervFox theme files
cp -r "$THEME_DIR/chrome/"* "$CHROME/"

# ensure userChrome.css exists
if [ ! -f "$CHROME/userChrome.css" ]; then
    FIRST_CSS="$(find "$CHROME" -maxdepth 1 -name '*.css' | head -n1)"
    [ -n "$FIRST_CSS" ] && ln -s "$(basename "$FIRST_CSS")" "$CHROME/userChrome.css"
fi

echo "NervFox installed. Enable 'toolkit.legacyUserProfileCustomizations.stylesheets' in about:config."
