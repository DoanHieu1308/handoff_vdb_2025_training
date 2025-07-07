class EndPoint {
  static final EndPoint _instance = EndPoint._internal();

  factory EndPoint() => _instance;

  EndPoint._internal();

  static const String BASE_URL = '';

  ///AUTH
  // Đăng kí email.
  static const String SIGN_UP = "";
  // Đăng nhập email.
  static const String LOGIN = "";
}