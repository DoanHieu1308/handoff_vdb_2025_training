class EndPoint {
  static final EndPoint _instance = EndPoint._internal();

  factory EndPoint() => _instance;

  EndPoint._internal();

  static const String BASE_URL = "http://192.168.100.64:5000/v1/api";
  // static const String BASE_URL = "http://192.168.1.9:5000/v1/api";

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
  static const String ALL_FRIENDS_REQUESTS = "/friends";
  // get all friends suggestion
  static const String ALL_FRIENDS_SUGGESTIONS = "/user/all";
  // get all friends
  static const String ALL_FRIENDS_FOLLOWERS = "/follow/followers";
  // accept friend requests
  static const String FRIENDS_REQUESTS = "/friends/update-status";


  /// Profile user
  static const String USER_PROFILE = "/user/profile";
  static const String UPLOAD_AVATAR = "/user/upload-avatar";
  /// Follow
  static const String FOLLOW_REQUESTS = "/follow";

  /// Post
  // preview link
  static const String PREVIEW_LINK = "/posts/extract-link-metadata";
  // post status
  static const String POST_CREATE = "/posts/create";
  // get all post
  static const String POSTS = "/posts";

  /// Upload file
  static const String UPLOAD = "/upload";
}