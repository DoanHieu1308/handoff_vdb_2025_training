import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';

class AuthHelper {
  ///
  /// Lấy SharedPreferenceHelper trực tiếp
  ///
  static SharedPreferenceHelper getInstance() {
    return SharedPreferenceHelper.instance;
  }

  ///
  /// Lưu thông tin đăng ký thành công
  ///
  static Future<void> saveRegistrationData({
    required String accessToken,
    required String refreshToken,
    required String email,
    required String password,
  }) async {
    final helper = getInstance();
    await helper.setAccessToken(accessToken);
    await helper.setRefreshToken(refreshToken);
    await helper.setEmail(email);
    await helper.setPassword(password);
  }

  ///
  /// Lấy thông tin user hiện tại
  ///
  static Map<String, String?> getCurrentUserData() {
    final helper = getInstance();
    return {
      'accessToken': helper.getAccessToken,
      'refreshToken': helper.getRefreshToken,
      'email': helper.getEmail,
      'password': helper.getPassword,
    };
  }

  ///
  /// Kiểm tra trạng thái đăng nhập
  ///
  static bool isUserLoggedIn() {
    final helper = getInstance();
    return helper.isLoggedIn;
  }

  ///
  /// Đăng xuất - xóa tất cả dữ liệu
  ///
  static Future<void> logout() async {
    final helper = getInstance();
    await helper.clearAuthData();
  }
} 