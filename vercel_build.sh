#!/bin/bash
set -e

echo "🚀 Building Flutter Web..."

flutter clean
flutter pub get
flutter build web --release

echo "✅ Done! Output in build/web"
