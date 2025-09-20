class EndPoint {
  static final EndPoint _instance = EndPoint._internal();

  factory EndPoint() => _instance;

  EndPoint._internal();

  /// BE
  static const String BASE_URL = "https://be-handoff-vdb-2025-training-v3.vercel.app/v1/api";
  /// Web
  static const String BASE_URL_WEB = "https://handoff-vdb-2025-training.vercel.app";
  /// Chat bot
  static const String BASE_CHATBOT = "http://127.0.0.1:8000/chatbot";

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
  // feel
  static const String FEEL = "/feel";

  /// Upload file
  static const String UPLOAD = "/upload";

  /// Comment create post
  static const String COMMENT = '/comment';

  /// Chat bot
  static const String CHATBOT = '/comment';
}