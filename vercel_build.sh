#!/bin/bash
set -e  # dừng ngay khi có lỗi

# Chọn version Flutter cụ thể thay vì stable (giúp tránh lỗi khi Vercel build)
FLUTTER_VERSION=3.24.0

echo "🔽 Download Flutter SDK ($FLUTTER_VERSION)..."
git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION
export PATH="$PATH:`pwd`/flutter/bin"

echo "📌 Flutter version:"
flutter --version

echo "📦 Getting dependencies..."
flutter pub get

echo "🌐 Building Flutter Web (release)..."
flutter build web --release --base-href "/"

echo "✅ Build completed successfully!"
