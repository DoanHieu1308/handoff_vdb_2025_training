import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/dio_client.dart';
import 'package:handoff_vdb_2025/data/repositories/auth_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/follow_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/link_preview_store/link_preview_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/media_store/media_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/text_store/text_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/item_detail/item_detail_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/video/video_store.dart';
import '../../presentation/pages/create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';
import '../../presentation/pages/posts/post_item_store.dart';
import '../../presentation/pages/profile/pages/profile_page/profile_store.dart';
import '../../presentation/pages/profile/pages/profile_picture_camera/profile_picture_camera_store.dart';


class AppInit {
  static AppInit? _instance;
  static AppInit get instance => _instance ??= AppInit._init();

  AppInit._init();

  // Dio Client
  late final DioClient dioClient;

  // Shared Preferences
  late final SharedPreferenceHelper sharedPreferenceHelper;

  // Repositories
  late final AuthRepository authRepository;
  late final FriendRepository friendRepository;
  late final UserRepository userRepository;
  late final FollowRepository followRepository;
  late final PostRepository postRepository;

  // Stores
  late final LoginStore loginStore;
  late final SignUpStore signUpStore;
  late final DashBoardStore dashBoardStore;
  late final VideoStore videoStore;
  late final ProfilePictureCameraStore profilePictureCamera;
  late final ProfileStore profileStore;
  late final InfoFriendStore infoFriendStore;
  late final SearchStore searchStore;
  late final FriendsStore friendsStore;
  late final ItemDetailStore itemDetailStore;
  late final HomeStore homeStore;
  late final CreatePostStore createPostStore;
  late final CreatePostAdvancedOptionSettingStore createPostAdvancedOptionSettingStore;
  late final PostItemStore postStatusStore;

  /// sub store
  // Create store
  late final MediaStore mediaStore;
  late final LinkPreviewStore linkPreviewStore;
  late final TextStore textStore;


  /// Initialize all dependencies
  Future<void> init() async {
    try {
      // Initialize SharedPreferences first
      await _initSharedPreferences();

      // Initialize Dio Client
      await _initDioClient();

      // Initialize Repositories
      await _initRepositories();

      // Initialize Stores
      await _initStores();

      debugPrint('App initialization completed successfully');
    } catch (e) {
      debugPrint('App initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize SharedPreferences
  Future<void> _initSharedPreferences() async {
    try {
      await SharedPreferenceHelper.init();
      sharedPreferenceHelper = SharedPreferenceHelper.instance;
      debugPrint('SharedPreferences initialized');
    } catch (e) {
      debugPrint('SharedPreferences initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize Dio Client
  Future<void> _initDioClient() async {
    try {
      dioClient = DioClient();
      debugPrint('Dio Client initialized');
    } catch (e) {
      debugPrint('Dio Client initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize Repositories
  Future<void> _initRepositories() async {
    try {
      // Create repositories (they will initialize themselves)
      authRepository = AuthRepository();
      friendRepository = FriendRepository();
      userRepository = UserRepository();
      followRepository = FollowRepository();
      postRepository = PostRepository();
      debugPrint('Repositories initialized');
    } catch (e) {
      debugPrint('Repositories initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _initStores() async {
    try {
      // 1. Khởi tạo các store độc lập trước
      signUpStore = SignUpStore();
      loginStore = LoginStore();
      searchStore = SearchStore();
      videoStore = VideoStore();

      // 2. Khởi tạo FriendsStore (phụ thuộc vào SearchStore)
      friendsStore = FriendsStore();

      // 3. Khởi tạo InfoFriendStore (phụ thuộc vào FriendsStore qua lazy getter)
      infoFriendStore = InfoFriendStore();

      // 4. Khởi tạo các store phụ thuộc vào FriendsStore
      profileStore = ProfileStore();

      homeStore = HomeStore();
      dashBoardStore = DashBoardStore();
      profilePictureCamera = ProfilePictureCameraStore();

      createPostStore = CreatePostStore();
      postStatusStore = PostItemStore();
      createPostAdvancedOptionSettingStore = CreatePostAdvancedOptionSettingStore();

      // 5. Khởi tạo ItemDetailStore cuối cùng (phụ thuộc vào FriendsStore qua constructor)
      itemDetailStore = ItemDetailStore(friendsStore);

      /// Sub store
      mediaStore = MediaStore(createPostStore);
      linkPreviewStore = LinkPreviewStore(createPostStore);
      textStore = TextStore(createPostStore);

      
      debugPrint('Stores initialized');
    } catch (e) {
      debugPrint('Stores initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize ScreenUtil
  void initScreenUtil(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }

  /// Dispose all resources
  void dispose() {
    try {
      // Dispose stores if needed
      dashBoardStore.disposeAll();
      profileStore.disposeAll();
      searchStore.disposeAll();
      
      debugPrint('App resources disposed');
    } catch (e) {
      debugPrint('App disposal failed: $e');
    }
  }

  /// Get all stores as a map for dependency injection
  Map<String, dynamic> getStores() {
    return {
      'loginStore': loginStore,
      'signUpStore': signUpStore,
      'dashBoardStore': dashBoardStore,
      'profileStore': profileStore,
      'searchStore': searchStore,
    };
  }

  /// Get all repositories as a map for dependency injection
  Map<String, dynamic> getRepositories() {
    return {
      'authRepository': authRepository,
      'friendRepository': friendRepository,
      'userRepository': userRepository,
    };
  }
} 