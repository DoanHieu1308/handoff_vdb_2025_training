class EndPoint {
  static final EndPoint _instance = EndPoint._internal();

  factory EndPoint() => _instance;

  EndPoint._internal();

  static const String BASE_URL = "http://192.168.100.64:5000/v1/api";

  ///AUTH
  // Đăng kí email.
  static const String SIGN_UP = "/auth/register";
  // Đăng nhập email.
  static const String LOGIN = "/auth/login";
  // Refresh token
  static const String REFRESH_TOKEN = "/auth/refresh-token";

  ///Friend
  // get all friends
  static const String ALL_FRIENDS = "/friends/list";
  // get all friend requests
  static const String ALL_FRIENDS_REQUESTS = "/friends/pending";
  // accept friend requests
  static const String ACCEPT_FRIENDS_REQUESTS = "/friends/accept";
  // accept friend requests
  static const String REJECT_FRIENDS_REQUESTS = "/friends/reject";

  /// Profile
  static const String USER_PROFILE = "/users/profile";
}