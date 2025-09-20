#!/bin/bash
set -e  # Exit on any error

# Download Flutter SDK
echo "Downloading Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Getting dependencies..."
flutter pub get

echo "Building for web..."
flutter build web --release

echo "Build completed successfully!"
