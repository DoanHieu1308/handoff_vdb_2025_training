#!/bin/bash
set -e  # dừng script ngay khi có lỗi

echo "🚀 Start Flutter Web Build (Local Test)..."

# Kiểm tra Flutter đã cài chưa
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter chưa cài đặt hoặc chưa có trong PATH"
    exit 1
fi

# Kiểm tra version Flutter
echo "✅ Flutter version:"
flutter --version

# Cài dependencies
echo "📦 Running flutter pub get..."
flutter pub get

# Clean build cũ
echo "🧹 Cleaning old build..."
flutter clean

# Build Flutter Web
echo "🔨 Building Flutter Web..."
flutter build web --release --source-maps

# Kiểm tra output
echo "📁 Build output:"
ls -la build/web

echo "✅ Flutter Web build completed! Ready for deploy."
