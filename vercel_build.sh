#!/bin/bash
set -e  # dừng script khi có lỗi

echo "🚀 Start Flutter Web Build..."

# Tải Flutter SDK (stable - latest)
if [ ! -d "flutter" ]; then
  echo "📥 Downloading Flutter SDK (latest stable)..."
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
fi

# Thêm Flutter vào PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# Kiểm tra Flutter version
echo "✅ Flutter version:"
flutter --version

# Cài dependencies
echo "📦 Running flutter pub get..."
flutter pub get

# Clean build cũ
echo "🧹 Cleaning old build..."
flutter clean

# Build Flutter Web với options tương thích
echo "🔨 Building Flutter Web..."
flutter build web --release --source-maps

# Kiểm tra output
echo "📁 Build output:"
ls -la build/web

echo "✅ Flutter Web build completed! Ready for deploy."
