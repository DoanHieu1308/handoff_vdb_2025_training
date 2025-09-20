import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';

/// Service để xử lý tất cả deep links trong ứng dụng
/// Đồng bộ với tất cả routes trong AuthRoutes
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late GoRouter _router;

  /// Khởi tạo service với router
  void initialize(GoRouter router) {
    _router = router;
  }

  /// Xử lý deep link chính
  /// Nhận Uri và route đến đúng trang
  Future<void> handleDeepLink(Uri uri) async {
    if (kDebugMode) {
      print("🔗 DeepLinkService: Processing URI: $uri");
    }

    try {
      final pathSegments = uri.pathSegments;
      final scheme = uri.scheme;
      final host = uri.host;

      // Kiểm tra scheme
      if (scheme != 'handoff') {
        if (kDebugMode) {
          print("DeepLinkService: Invalid scheme '$scheme'. Expected 'handoff'");
        }
        return;
      }

      // Xử lý theo host
      switch (host) {
        case 'dashboard':
          await _handleDashboardRoute(pathSegments);
          break;
        case 'posts':
          await _handlePostsRoute(pathSegments);
          break;
        case 'auth':
          await _handleAuthRoute(pathSegments);
          break;
        case 'social':
          await _handleSocialRoute(pathSegments);
          break;
        case 'media':
          await _handleMediaRoute(pathSegments);
          break;
        default:
          await _handleDefaultRoute(host, pathSegments);
      }
    } catch (e) {
      if (kDebugMode) {
        print("DeepLinkService: Error handling deep link: $e");
      }
    }
  }

  /// Xử lý dashboard routes
  /// handoff://dashboard/video, handoff://dashboard/friends, etc.
  Future<void> _handleDashboardRoute(List<String> pathSegments) async {
    if (pathSegments.isEmpty) {
      // handoff://dashboard
      _router.push(AuthRoutes.DASH_BOARD);
      return;
    }

    final subRoute = pathSegments.first;
    switch (subRoute) {
      case 'video':
        _router.push('/dashboard/video');
        break;
      case 'friends':
        _router.push('/dashboard/friends');
        break;
      case 'profile':
        _router.push('/dashboard/profile');
        break;
      case 'home':
        _router.push('/dashboard/home');
        break;
      default:
        // Fallback to main dashboard
        _router.push(AuthRoutes.DASH_BOARD);
    }
  }

  /// Xử lý posts routes
  /// handoff://posts/{id}
  Future<void> _handlePostsRoute(List<String> pathSegments) async {
    if (pathSegments.isEmpty) {
      if (kDebugMode) {
        print("DeepLinkService: Posts route requires post ID");
      }
      return;
    }

    final postId = pathSegments.first;
    final route = AuthRoutes.POSTS.replaceAll(':id', postId);
    _router.push(route);
  }

  /// Xử lý authentication routes
  /// handoff://auth/login, handoff://auth/signup
  Future<void> _handleAuthRoute(List<String> pathSegments) async {
    if (pathSegments.isEmpty) {
      _router.push(AuthRoutes.LOGIN);
      return;
    }

    final authType = pathSegments.first;
    switch (authType) {
      case 'login':
        _router.push(AuthRoutes.LOGIN);
        break;
      case 'signup':
      case 'sign_up':
        _router.push(AuthRoutes.SIGNUP);
        break;
      default:
        _router.push(AuthRoutes.LOGIN);
    }
  }

  /// Xử lý social routes
  /// handoff://social/friends, handoff://social/chat, etc.
  Future<void> _handleSocialRoute(List<String> pathSegments) async {
    if (pathSegments.isEmpty) {
      _router.push(AuthRoutes.FRIENDS);
      return;
    }

    final socialType = pathSegments.first;
    switch (socialType) {
      case 'friends':
        _router.push(AuthRoutes.FRIENDS);
        break;
      case 'info_friends':
        _router.push(AuthRoutes.INFO_FRIENDS);
        break;
      case 'all_friend':
        _router.push(AuthRoutes.ALL_FRIEND);
        break;
      case 'chat':
        // handoff://social/chat/{userId} - cần userId
        if (pathSegments.length > 1) {
          if (kDebugMode) {
            print("⚠DeepLinkService: Chat route requires UserModel implementation for userId: ${pathSegments[1]}");
          }
        } else {
          _router.push(AuthRoutes.MESSENGER);
        }
        break;
      case 'messenger':
        _router.push(AuthRoutes.MESSENGER);
        break;
      case 'conversation':
        _router.push(AuthRoutes.CONVERSATION);
        break;
      default:
        _router.push(AuthRoutes.FRIENDS);
    }
  }

  /// Xử lý media routes
  /// handoff://media/create, handoff://media/camera, etc.
  Future<void> _handleMediaRoute(List<String> pathSegments) async {
    if (pathSegments.isEmpty) {
      _router.push(AuthRoutes.DASH_BOARD);
      return;
    }

    final mediaType = pathSegments.first;
    switch (mediaType) {
      case 'create':
        _router.push(AuthRoutes.CREATE_POST);
        break;
      case 'camera':
        _router.push(AuthRoutes.CAMERA);
        break;
      case 'status':
        _router.push(AuthRoutes.STATUS_POST);
        break;
      case 'tag_friend':
        _router.push(AuthRoutes.TAG_FRIEND);
        break;
      case 'image_viewer':
        _router.push(AuthRoutes.IMAGE_VIEWER);
        break;
      case 'chat_media':
        _router.push(AuthRoutes.CHAT_CUSTOM_SHOW_MEDIA);
        break;
      default:
        _router.push(AuthRoutes.DASH_BOARD);
    }
  }

  /// Xử lý default routes (fallback)
  Future<void> _handleDefaultRoute(String host, List<String> pathSegments) async {
    if (kDebugMode) {
      print("⚠️ DeepLinkService: Unknown host '$host', falling back to dashboard");
    }
    _router.push(AuthRoutes.DASH_BOARD);
  }

  /// Tạo deep link URL cho các route phổ biến
  static String createDeepLink({
    required String host,
    List<String>? pathSegments,
    Map<String, String>? queryParameters,
  }) {
    final uri = Uri(
      scheme: 'handoff',
      host: host,
      pathSegments: pathSegments ?? [],
      queryParameters: queryParameters ?? {},
    );
    return uri.toString();
  }

  /// Helper methods để tạo deep links phổ biến
  static String createDashboardLink([String? tab]) {
    return createDeepLink(
      host: 'dashboard',
      pathSegments: tab != null ? [tab] : null,
    );
  }

  static String createPostLink(String postId) {
    return createDeepLink(
      host: 'posts',
      pathSegments: [postId],
    );
  }

  static String createAuthLink(String authType) {
    return createDeepLink(
      host: 'auth',
      pathSegments: [authType],
    );
  }

  static String createSocialLink(String socialType, [String? userId]) {
    return createDeepLink(
      host: 'social',
      pathSegments: userId != null ? [socialType, userId] : [socialType],
    );
  }

  static String createMediaLink(String mediaType) {
    return createDeepLink(
      host: 'media',
      pathSegments: [mediaType],
    );
  }
}

/// Extension để dễ dàng tạo deep links từ AuthRoutes
extension AuthRoutesDeepLink on AuthRoutes {
  /// Tạo deep link cho dashboard
  static String get dashboardDeepLink => DeepLinkService.createDashboardLink();
  
  /// Tạo deep link cho dashboard với tab cụ thể
  static String dashboardTabDeepLink(String tab) => DeepLinkService.createDashboardLink(tab);
  
  /// Tạo deep link cho post
  static String postDeepLink(String postId) => DeepLinkService.createPostLink(postId);
  
  /// Tạo deep link cho auth
  static String authDeepLink(String authType) => DeepLinkService.createAuthLink(authType);
  
  /// Tạo deep link cho social
  static String socialDeepLink(String socialType, [String? userId]) => 
      DeepLinkService.createSocialLink(socialType, userId);
  
  /// Tạo deep link cho media
  static String mediaDeepLink(String mediaType) => DeepLinkService.createMediaLink(mediaType);
}
