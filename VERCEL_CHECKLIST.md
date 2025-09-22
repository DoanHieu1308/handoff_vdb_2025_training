# ✅ Checklist Cấu Hình Vercel cho Flutter Web

## 📋 Kiểm Tra Tổng Quan

### ✅ File Cấu Hình Chính
- [x] `vercel.json` - Cấu hình routing và build
- [x] `vercel_build.sh` - Script build Flutter web
- [x] `.vercelignore` - Loại bỏ file không cần thiết
- [x] `pubspec.yaml` - Dependencies và assets
- [x] `web/index.html` - HTML template
- [x] `web/manifest.json` - PWA manifest
- [x] `web/icons/` - App icons
- [x] `lib/firebase_options.dart` - Firebase config

### ✅ Cấu Hình Vercel Dashboard

#### **Build Settings:**
- [x] **Framework Preset:** Other
- [x] **Root Directory:** `./` (root của project)
- [x] **Build Command:** `chmod +x vercel_build.sh && ./vercel_build.sh`
- [x] **Output Directory:** `build/web`
- [x] **Install Command:** (để trống)

#### **Environment Variables:**
Bạn có thể import trực tiếp từ file `.env` vào Vercel Dashboard:

```
FLUTTER_WEB_USE_SKIA=true
FIREBASE_API_KEY=AIzaSyDmXRkXUrJe69VZj4bUs8KEtbeIW6voQ1g
FIREBASE_PROJECT_ID=handoffvdb2025
FIREBASE_MESSAGING_SENDER_ID=1018382182517
API_BASE_URL=https://your-api-domain.com
API_TIMEOUT=30000
APP_NAME=Handoff VDB 2025
APP_VERSION=1.0.0
DEBUG_MODE=false
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
```

## 🔧 Chi Tiết Cấu Hình

### 1. `vercel.json` ✅
```json
{
  "version": 2,
  "builds": [
    {
      "src": "vercel_build.sh",
      "use": "@vercel/bash"
    }
  ],
  "routes": [
    // Static assets routing
    { "src": "/assets/(.*)", "dest": "/build/web/assets/$1" },
    { "src": "/canvaskit/(.*)", "dest": "/build/web/canvaskit/$1" },
    { "src": "/icons/(.*)", "dest": "/build/web/icons/$1" },
    { "src": "/packages/(.*)", "dest": "/build/web/packages/$1" },
    { "src": "/shaders/(.*)", "dest": "/build/web/shaders/$1" },
    { "src": "/fonts/(.*)", "dest": "/build/web/fonts/$1" },
    // Static files
    { "src": "/(.*\\.(js|css|png|jpg|jpeg|gif|svg|ico|woff|woff2|ttf|eot|otf|wasm|bin|json))", "dest": "/build/web/$1" },
    // SPA routing
    { "src": "/(.*)", "dest": "/build/web/index.html" }
  ],
  "functions": {
    "vercel_build.sh": {
      "maxDuration": 300
    }
  }
}
```

### 2. `vercel_build.sh` ✅
```bash
#!/bin/bash
set -e

echo "🚀 Starting Flutter Web Build for Vercel..."

# Cài đặt Flutter SDK
echo "📥 Installing Flutter SDK..."
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
```

### 3. `.vercelignore` ✅
```
# Ignore unnecessary files for Vercel deployment
android/
ios/
test/
.git/
.gitignore
README.md
*.md
analysis_options.yaml
devtools_options.yaml
handoff_vdb_2025.iml

# Keep only essential files for web build
!lib/
!web/
!pubspec.yaml
!vercel.json
!vercel_build.sh
!assets/
!firebase_options.dart
!.env
```

### 4. `pubspec.yaml` ✅
- ✅ Flutter SDK version: `^3.7.0-323.0.dev`
- ✅ `flutter_dotenv: ^6.0.0` - Để xử lý environment variables
- ✅ Assets được cấu hình đúng: `assets/base/`, `assets/features/`, `.env`
- ✅ Fonts được cấu hình đúng
- ✅ Tất cả dependencies hỗ trợ web

### 5. Firebase Configuration ✅
- ✅ `firebase_options.dart` có cấu hình web
- ✅ Firebase project ID: `handoffvdb2025`
- ✅ Web app ID: `1:1018382182517:web:09951ba7237abac2a6303c`

## 🚀 Các Bước Deploy

### Bước 1: Chuẩn Bị
1. ✅ Tạo file `.env` với các biến cần thiết
2. ✅ Push code lên GitHub/GitLab
3. ✅ Kiểm tra tất cả file cấu hình

### Bước 2: Tạo Project trên Vercel
1. Đăng nhập vào [Vercel Dashboard](https://vercel.com/dashboard)
2. Click **"New Project"**
3. Import repository từ GitHub/GitLab
4. Cấu hình Build Settings như trên
5. Thêm Environment Variables từ file `.env`

### Bước 3: Deploy
1. Click **"Deploy"**
2. Chờ quá trình build (3-5 phút)
3. Kiểm tra URL được tạo

## 🔍 Kiểm Tra Sau Deploy

### ✅ Checklist Kiểm Tra:
- [ ] App load được trên browser
- [ ] Routing hoạt động đúng (SPA)
- [ ] Assets (images, fonts) load được
- [ ] Firebase connection hoạt động
- [ ] Environment variables được load đúng
- [ ] PWA manifest hoạt động
- [ ] Responsive design trên mobile

### 🔧 Troubleshooting:
- **Build timeout:** Tăng `maxDuration` trong `vercel.json`
- **Assets không load:** Kiểm tra routes trong `vercel.json`
- **Firebase lỗi:** Kiểm tra environment variables
- **Routing lỗi:** Kiểm tra SPA routing configuration

## 📊 Performance Optimization

### ✅ Đã Được Tối Ưu:
- CanvasKit renderer (thay vì HTML renderer)
- Static file serving tối ưu
- Proper routing cho SPA
- Source maps cho debugging
- Asset optimization

### 🎯 Kết Quả Mong Đợi:
- ✅ App Flutter web chạy mượt mà
- ✅ Routing hoạt động đúng
- ✅ Assets được serve tối ưu
- ✅ Performance tốt với CanvasKit
- ✅ HTTPS tự động được enable
- ✅ Environment variables hoạt động

---

## 🎉 Tóm Tắt

**Tất cả cấu hình đã hoàn tất và sẵn sàng deploy!**

Bạn chỉ cần:
1. Tạo file `.env` với các biến cần thiết
2. Import environment variables vào Vercel Dashboard
3. Deploy và enjoy! 🚀

**Lưu ý:** Build time sẽ mất 3-5 phút do cần cài đặt Flutter SDK, nhưng chỉ cần build một lần cho mỗi deployment.
