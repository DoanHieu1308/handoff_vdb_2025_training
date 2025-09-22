#!/bin/bash
set -e

echo "🚀 Start Flutter Web Build on Vercel..."

# Clone Flutter SDK nếu chưa có
if [ ! -d "flutter" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
fi
export PATH="$PATH:$(pwd)/flutter/bin"

flutter --version

echo "📦 Installing dependencies..."
flutter pub get

echo "🔨 Building Flutter Web..."
flutter build web --release

echo "✅ Done! Output in build/web"
