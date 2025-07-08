import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../exception/api_error_handler.dart';
import '../model/auth/auth_model.dart';
import '../model/base/api_response.dart';
import '../model/response/user_model.dart';


class FakeAuthRepository {
  List<UserModel> _fakeUsers = [];

  bool _hasLoaded = false;

  Future<File> _getUserFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  Future<void> _initUserFile() async {
    final file = await _getUserFile();
    if (!(await file.exists())) {
      try {
        final data = await rootBundle.loadString('assets/data_fake/users.json');
        await file.writeAsString(data);
        print('✅ Đã tạo file users.json từ assets');
      } catch (e) {
        print('❌ Lỗi khi tạo file từ assets: $e');
        // Tạo file với dữ liệu mặc định
        final defaultUsers = [
          {
            "id": "u001",
            "name": "Nguyen Van A",
            "email": "a@example.com",
            "password": "pw1",
            "avatar": "assets/features/avata1.png",
            "bio": "Yêu thích công nghệ.",
            "createdAt": "2025-01-01T08:00:00Z",
            "updatedAt": "2025-01-01T08:00:00Z"
          }
        ];
        await file.writeAsString(json.encode(defaultUsers));
        print('✅ Đã tạo file với dữ liệu mặc định');
      }
    }
  }

  Future<void> loadUserFromJson() async {
    if (_hasLoaded) return;
    await _initUserFile();

    try {
      final file = await _getUserFile();
      final content = await file.readAsString();
      final jsonData = json.decode(content) as List<dynamic>;

      _fakeUsers = jsonData.map((e) => UserModel.fromMap(e)).toList();
      _hasLoaded = true;
      print('✅ Đã load ${_fakeUsers.length} users từ file');
    } catch (e) {
      print('❌ Lỗi khi load users: $e');
      // Fallback: tạo danh sách rỗng
      _fakeUsers = [];
      _hasLoaded = true;
    }
  }

  Future<void> _saveUsersToJson() async {
    final file = await _getUserFile();
    final content = json.encode(_fakeUsers.map((u) => u.toMap()).toList());
    await file.writeAsString(content);
    print('✅ Đã lưu dữ liệu vào: ${file.path}');
  }


  /// Fake sign up
  Future<void> signUpEmail({
    required UserModel data,
    required Function(AuthModel data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    try {
      await loadUserFromJson();

      // Check if email already exists
      final existing = _fakeUsers.any((user) => user.email == data.email);
      if (existing) {
        onError("Email đã tồn tại trong hệ thống.");
        return;
      }

      // Fake server processing delay
      await Future.delayed(Duration(milliseconds: 500));

      // Create new user
      final newUser = data.copyWith(
        id: "u${_fakeUsers.length + 1}".padLeft(4, '0'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _fakeUsers.add(newUser);

      await _saveUsersToJson();

      final authModel = AuthModel(
        user: newUser,
        accessToken: "fake-access-token-${newUser.id}",
        refreshToken: "fake-refresh-token-${newUser.id}",
      );

      onSuccess(authModel);
      
      // In ra thông tin để debug
      print('Đã đăng ký thành công user: ${newUser.name} (${newUser.email})');
      print('Tổng số users hiện tại: ${_fakeUsers.length}');
      
    } catch (e) {
      print('❌ Lỗi chi tiết: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      onError("Đã xảy ra lỗi: ${e.toString()}");
    }
  }

  /// Method để xem tất cả users (debug)
  Future<void> printAllUsers() async {
    await loadUserFromJson();
    print('=== DANH SÁCH TẤT CẢ USERS ===');
    for (var user in _fakeUsers) {
      print('ID: ${user.id}, Name: ${user.name}, Email: ${user.email}');
    }
    print('===============================');
  }

  /// Method để export dữ liệu ra file gốc (chỉ dùng cho development)
  Future<void> exportToOriginalFile() async {
    try {
      await loadUserFromJson();
      final content = json.encode(_fakeUsers.map((u) => u.toMap()).toList());
      
      // Đường dẫn tuyệt đối đến file gốc trong assets
      final originalFile = File('E:/Source_training/handoff_vdb_2025/assets/data_fake/users.json');
      await originalFile.writeAsString(content);
      print('✅ Đã export dữ liệu ra file gốc: ${originalFile.path}');
    } catch (e) {
      print('❌ Không thể export: $e');
      print('Lý do: File không tồn tại hoặc không có quyền ghi');
    }
  }
}
