#!/bin/bash
set -e  # dừng ngay khi có lỗi

echo "🚀 Starting Flutter Web Build for Vercel..."

# Cài đặt Flutter SDK
echo "📥 Installing Flutter SDK..."
FLUTTER_VERSION="3.24.0"
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# Kiểm tra Flutter version
echo "✅ Flutter version:"
flutter --version

# Cài đặt dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Clean build directory
echo "🧹 Cleaning previous build..."
flutter clean

# Build Flutter web với các tùy chọn tối ưu
echo "🔨 Building Flutter Web (release mode)..."
flutter build web \
  --release \
  --web-renderer canvaskit \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --source-maps \
  --verbose

# Kiểm tra build output
echo "📁 Build output structure:"
ls -la build/web/

echo "✅ Build completed successfully!"
echo "🎉 Ready for Vercel deployment!"
