#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

swift build -c release

APP="Togglan.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/Togglan "$APP/Contents/MacOS/Togglan"
cp Info.plist "$APP/Contents/Info.plist"
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

echo "Built $APP"
