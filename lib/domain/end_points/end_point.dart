class EndPoint {
  static final EndPoint _instance = EndPoint._internal();

  factory EndPoint() => _instance;

  EndPoint._internal();

  static const String BASE_URL = "http://192.168.100.64:5000/v1/api";
  // static const String BASE_URL = "http://192.168.1.8:5000/v1/api";

  ///AUTH
  // Đăng kí email.
  static const String SIGN_UP = "/auth/register";
  // Đăng nhập email.
  static const String LOGIN = "/auth/login";
  // Refresh token
  static const String REFRESH_TOKEN = "/auth/refresh-token";
  // Đăng xuất
  static const String LOGOUT = "/auth/logout";

  ///Friend
  // get all friends
  static const String ALL_FRIENDS = "/friends/list/all";
  // get all friend requests
  static const String ALL_FRIENDS_REQUESTS = "/friends/list/pending";
  // get all friends
  static const String ALL_FRIENDS_SUGGESTIONS = "/users";
  // accept friend requests
  static const String FRIENDS_REQUESTS = "/friends/requests";


  /// Profile
  static const String USER_PROFILE = "/users/profile";
}