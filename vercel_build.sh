#!/bin/bash
set -e

# Ensure LF line endings only
# Run this on your machine before pushing:
#   dos2unix vercel_build.sh

echo "Downloading Flutter SDK..."
git clone --depth 1 https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$(pwd)/flutter/bin"

echo "Flutter version:"
flutter --version

# Go to project directory (where pubspec.yaml is)
cd $(dirname "$0")

echo "Getting dependencies..."
flutter pub get

echo "Building for web..."
flutter build web --release --base-href /

echo "Build completed successfully!"
