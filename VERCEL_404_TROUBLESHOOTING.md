# 🔧 Troubleshooting 404 Error trên Vercel

## 🚨 Vấn Đề Hiện Tại

URL `https://handoff-vdb-2025-training-v21.vercel.app/dashboard/home` trả về **404: NOT_FOUND**

## 🔍 Nguyên Nhân

### 1. **Flutter Routing Configuration**
- Flutter app sử dụng `usePathUrlStrategy()` (dòng 58 trong main.dart)
- Route `/dashboard/home` không tồn tại trong Flutter app
- Route thực tế là `/home` (nested route của `/dashboard`)

### 2. **Vercel Routing Configuration**
- Cấu hình routing trong `vercel.json` có thể chưa đúng
- Cần đảm bảo SPA routing hoạt động đúng

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Routes Trong Flutter App

Theo `lib/core/enums/auth_enums.dart`:
```dart
static const String DASH_BOARD = '/dashboard';
static const String Home = '/home';  // Nested route của dashboard
```

**Routes hợp lệ:**
- ✅ `/login`
- ✅ `/sign_up` 
- ✅ `/dashboard` (sẽ redirect đến `/home`)
- ✅ `/home`
- ✅ `/video`
- ✅ `/friends`
- ✅ `/profile`
- ✅ `/chat_bot`

**Routes KHÔNG hợp lệ:**
- ❌ `/dashboard/home` (không tồn tại)
- ❌ `/dashboard/video` (không tồn tại)

### Bước 2: Cấu Hình Vercel Đã Được Sửa

File `vercel.json` đã được cập nhật với cấu hình đúng:

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
    {
      "src": "/assets/(.*)",
      "dest": "/build/web/assets/$1"
    },
    {
      "src": "/canvaskit/(.*)",
      "dest": "/build/web/canvaskit/$1"
    },
    {
      "src": "/icons/(.*)",
      "dest": "/build/web/icons/$1"
    },
    {
      "src": "/packages/(.*)",
      "dest": "/build/web/packages/$1"
    },
    {
      "src": "/shaders/(.*)",
      "dest": "/build/web/shaders/$1"
    },
    {
      "src": "/fonts/(.*)",
      "dest": "/build/web/fonts/$1"
    },
    {
      "src": "/(.*\\.(js|css|png|jpg|jpeg|gif|svg|ico|woff|woff2|ttf|eot|otf|wasm|bin|json))",
      "dest": "/build/web/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/build/web/index.html"
    }
  ],
  "functions": {
    "vercel_build.sh": {
      "maxDuration": 300
    }
  }
}
```

### Bước 3: Test URLs Đúng

**Thay vì:** `https://handoff-vdb-2025-training-v21.vercel.app/dashboard/home`

**Hãy thử:**
- ✅ `https://handoff-vdb-2025-training-v21.vercel.app/` (root)
- ✅ `https://handoff-vdb-2025-training-v21.vercel.app/login`
- ✅ `https://handoff-vdb-2025-training-v21.vercel.app/dashboard`
- ✅ `https://handoff-vdb-2025-training-v21.vercel.app/home`

## 🚀 Các Bước Khắc Phục

### 1. **Redeploy với cấu hình mới:**
```bash
# Push code mới lên GitHub
git add .
git commit -m "Fix Vercel routing configuration"
git push

# Hoặc redeploy trên Vercel Dashboard
```

### 2. **Kiểm tra Build Logs:**
- Vào Vercel Dashboard → Project → Deployments
- Click vào deployment mới nhất
- Kiểm tra Build Logs để đảm bảo không có lỗi

### 3. **Test từng URL:**
1. **Root URL:** `https://handoff-vdb-2025-training-v21.vercel.app/`
2. **Login:** `https://handoff-vdb-2025-training-v21.vercel.app/login`
3. **Dashboard:** `https://handoff-vdb-2025-training-v21.vercel.app/dashboard`
4. **Home:** `https://handoff-vdb-2025-training-v21.vercel.app/home`

### 4. **Kiểm tra Browser Console:**
- Mở Developer Tools (F12)
- Kiểm tra Console tab để xem lỗi JavaScript
- Kiểm tra Network tab để xem requests

## 🔍 Debug Steps

### 1. **Kiểm tra Flutter App có load không:**
```bash
# Test root URL
curl -I https://handoff-vdb-2025-training-v21.vercel.app/
# Should return 200 OK
```

### 2. **Kiểm tra Static Assets:**
```bash
# Test assets
curl -I https://handoff-vdb-2025-training-v21.vercel.app/assets/
# Should return 200 OK
```

### 3. **Kiểm tra JavaScript Files:**
```bash
# Test main.dart.js
curl -I https://handoff-vdb-2025-training-v21.vercel.app/main.dart.js
# Should return 200 OK
```

## 📋 Checklist Khắc Phục

- [ ] ✅ Cập nhật `vercel.json` với cấu hình đúng
- [ ] 🔄 Push code mới lên GitHub
- [ ] 🔄 Redeploy trên Vercel
- [ ] 🔍 Kiểm tra Build Logs
- [ ] 🔍 Test root URL: `/`
- [ ] 🔍 Test login URL: `/login`
- [ ] 🔍 Test dashboard URL: `/dashboard`
- [ ] 🔍 Test home URL: `/home`
- [ ] 🔍 Kiểm tra Browser Console
- [ ] 🔍 Kiểm tra Network requests

## 🎯 Kết Quả Mong Đợi

Sau khi khắc phục:
- ✅ Root URL (`/`) load được Flutter app
- ✅ Login page (`/login`) hiển thị đúng
- ✅ Dashboard (`/dashboard`) redirect đến home
- ✅ Home page (`/home`) hiển thị đúng
- ✅ Navigation giữa các pages hoạt động
- ✅ Browser refresh không bị 404

## 🚨 Nếu Vẫn Bị 404

### 1. **Kiểm tra Build Output:**
```bash
# Kiểm tra xem build/web có đúng không
ls -la build/web/
```

### 2. **Kiểm tra Vercel Build Logs:**
- Có thể build bị fail
- Có thể Flutter SDK không cài đặt đúng
- Có thể dependencies có vấn đề

### 3. **Thử cấu hình đơn giản hơn:**
```json
{
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

---

**Lưu ý:** Sau khi redeploy, hãy đợi 2-3 phút để Vercel cache được clear và test lại!
