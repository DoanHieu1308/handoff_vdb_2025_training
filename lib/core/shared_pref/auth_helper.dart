import 'shared_preference_helper.dart';

class AuthHelper {
  static SharedPreferenceHelper? _instance;
  
  ///
  /// Khởi tạo SharedPreferenceHelper
  ///
  static Future<SharedPreferenceHelper> getInstance() async {
    _instance =  SharedPreferenceHelper.instance;
    return _instance!;
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
    final helper = await getInstance();
    await helper.setAccessToken(accessToken);
    await helper.setRefreshToken(refreshToken);
    await helper.setEmail(email);
    await helper.setPassword(password);
  }

  ///
  /// Lấy thông tin user hiện tại
  ///
  static Future<Map<String, String?>> getCurrentUserData() async {
    final helper = await getInstance();
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
  static Future<bool> isUserLoggedIn() async {
    final helper = await getInstance();
    return helper.isLoggedIn;
  }

  ///
  /// Đăng xuất - xóa tất cả dữ liệu
  ///
  static Future<void> logout() async {
    final helper = await getInstance();
    await helper.clearAuthData();
  }
} 