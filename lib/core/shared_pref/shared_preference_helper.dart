import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;
  static SharedPreferenceHelper? _instance;

  final SharedPreferences _sharedPreference;

  SharedPreferenceHelper._internal(this._sharedPreference);

  static Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = SharedPreferenceHelper._internal(_prefs!);
    }
  }

  static SharedPreferenceHelper get instance {
    if (_instance == null) {
      throw Exception("SharedPreferenceHelper not initialized. Call SharedPreferenceHelper.init() first.");
    }
    return _instance!;
  }

  // General Methods: Access token
  String? get getAccessToken => _sharedPreference.getString(Preferences.accessToken);
  Future<void> setAccessToken(String token) async {
    await _sharedPreference.setString(Preferences.accessToken, token);
  }

  String? get getRefreshToken => _sharedPreference.getString(Preferences.refreshToken);
  Future<void> setRefreshToken(String token) async =>
      await _sharedPreference.setString(Preferences.refreshToken, token);

  // Email
  String? get getEmail => _sharedPreference.getString(Preferences.email);
  Future<void> setEmail(String email) async =>
      await _sharedPreference.setString(Preferences.email, email);

  // Password
  String? get getPassword => _sharedPreference.getString(Preferences.password);
  Future<void> setPassword(String password) async =>
      await _sharedPreference.setString(Preferences.password, password);

  ///
  /// Set id user.
  ///
  String? get getIdUser => _sharedPreference.getString(Preferences.idUser);

  Future<void> setIdUser(String idUser) async =>
      await _sharedPreference.setString(Preferences.idUser, idUser);

  Future<void> removeIdUser() async =>
      await _sharedPreference.remove(Preferences.idUser);

  ///
  /// Xóa tất cả dữ liệu authentication
  ///
  Future<void> clearAuthData() async {
    // await setAccessToken("");
    // await setRefreshToken("");
    await _sharedPreference.remove(Preferences.accessToken);
    await _sharedPreference.remove(Preferences.refreshToken);
  }

  ///
  /// Kiểm tra xem user đã đăng nhập chưa
  ///
  bool get isLoggedIn {
    final accessToken = getAccessToken;
    return accessToken != null && accessToken.isNotEmpty;
  }
}