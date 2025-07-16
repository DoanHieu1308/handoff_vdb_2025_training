import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/dio_client.dart';
import 'package:handoff_vdb_2025/data/repositories/auth_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/item_detail/item_detail_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/profile_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/video/video_store.dart';

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

  // Stores
  late final LoginStore loginStore;
  late final SignUpStore signUpStore;
  late final DashBoardStore dashBoardStore;
  late final VideoStore videoStore;
  late final ProfileStore profileStore;
  late final InfoFriendStore infoFriendStore;
  late final SearchStore searchStore;
  late final FriendsStore friendsStore;
  late final ItemDetailStore itemDetailStore;


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
      debugPrint('Repositories initialized');
    } catch (e) {
      debugPrint('Repositories initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize Stores
  Future<void> _initStores() async {
    try {
      searchStore = SearchStore();
      friendsStore = FriendsStore();
      profileStore = ProfileStore();
      loginStore = LoginStore();
      signUpStore = SignUpStore();
      dashBoardStore = DashBoardStore();
      videoStore = VideoStore();
      infoFriendStore = InfoFriendStore();
      itemDetailStore = ItemDetailStore(friendsStore);
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