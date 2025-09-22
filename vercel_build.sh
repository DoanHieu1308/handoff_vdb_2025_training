#!/bin/bash
set -e  # stop khi có lỗi

echo "🚀 Start Flutter Web Build for Vercel..."

# Cài đặt Flutter SDK (stable)
FLUTTER_VERSION="3.24.0"
echo "📥 Downloading Flutter SDK $FLUTTER_VERSION..."
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
export PATH="$PATH:$(pwd)/flutter/bin"

# Kiểm tra Flutter
flutter --version

# Cài dependencies
echo "📦 Running flutter pub get..."
flutter pub get

# Clean build cũ
flutter clean

# Build Flutter Web (release + canvaskit)
echo "🔨 Building Flutter Web..."
flutter build web \
  --release \
  --web-renderer canvaskit \
  --source-maps

# Kiểm tra output
echo "📁 Build output (build/web):"
ls -la build/web

echo "✅ Flutter Web build completed!"
