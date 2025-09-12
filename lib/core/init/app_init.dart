import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/dio_client.dart';
import 'package:handoff_vdb_2025/data/repositories/auth_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/follow_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/data/services/firebase_chat_service.dart';
import 'package:handoff_vdb_2025/data/services/firebase_presence_service.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/chat_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/conversation_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/messenger/messenger_store.dart';
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

  // Core dependencies
  late final DioClient dioClient;
  late final SharedPreferenceHelper sharedPreferenceHelper;

  // Repositories
  late final AuthRepository authRepository;
  late final FriendRepository friendRepository;
  late final UserRepository userRepository;
  late final FollowRepository followRepository;
  late final PostRepository postRepository;

  // Store instances - lazy initialized
  LoginStore? _loginStore;
  SignUpStore? _signUpStore;
  DashBoardStore? _dashBoardStore;
  VideoStore? _videoStore;
  ProfilePictureCameraStore? _profilePictureCamera;
  ProfileStore? _profileStore;
  InfoFriendStore? _infoFriendStore;
  SearchStore? _searchStore;
  FriendsStore? _friendsStore;
  ItemDetailStore? _itemDetailStore;
  HomeStore? _homeStore;
  CreatePostStore? _createPostStore;
  CreatePostAdvancedOptionSettingStore? _createPostAdvancedOptionSettingStore;
  PostItemStore? _postItemStore;
  MediaStore? _mediaStore;
  LinkPreviewStore? _linkPreviewStore;
  TextStore? _textStore;
  ChatStore? _chatStore;
  MessengerStore? _messengerStore;
  ConversationStore? _conversationStore;
  
  // Firebase Presence Service
  FirebasePresenceService? _firebasePresenceService;
  FirebaseChatService? _firebaseChatService;

  /// Initialize all dependencies
  Future<void> init() async {
    try {
      // Initialize core dependencies first
      await _initCoreDependencies();
      
      // Initialize repositories
      await _initRepositories();

      debugPrint('App initialization completed successfully');
    } catch (e) {
      debugPrint('App initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize core dependencies
  Future<void> _initCoreDependencies() async {
    try {
      // Initialize SharedPreferences first
      await SharedPreferenceHelper.init();
      sharedPreferenceHelper = SharedPreferenceHelper.instance;
      debugPrint('SharedPreferences initialized');

      // Initialize Dio Client
      dioClient = DioClient();
      debugPrint('Dio Client initialized');
    } catch (e) {
      debugPrint('Core dependencies initialization failed: $e');
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

  /// Lazy getter for stores - only initialize when needed
  LoginStore get loginStore => _loginStore ??= LoginStore();
  SignUpStore get signUpStore => _signUpStore ??= SignUpStore();
  SearchStore get searchStore => _searchStore ??= SearchStore();
  VideoStore get videoStore => _videoStore ??= VideoStore();
  
  FriendsStore get friendsStore {
    _friendsStore ??= FriendsStore();
    return _friendsStore!;
  }
  
  InfoFriendStore get infoFriendStore {
    _infoFriendStore ??= InfoFriendStore();
    return _infoFriendStore!;
  }
  
  ProfileStore get profileStore {
    _profileStore ??= ProfileStore();
    return _profileStore!;
  }
  
  HomeStore get homeStore {
    _homeStore ??= HomeStore();
    return _homeStore!;
  }
  
  DashBoardStore get dashBoardStore {
    _dashBoardStore ??= DashBoardStore();
    return _dashBoardStore!;
  }
  
  ProfilePictureCameraStore get profilePictureCamera {
    _profilePictureCamera ??= ProfilePictureCameraStore();
    return _profilePictureCamera!;
  }
  
  CreatePostStore get createPostStore {
    _createPostStore ??= CreatePostStore();
    return _createPostStore!;
  }
  
  PostItemStore get postItemStore {
    _postItemStore ??= PostItemStore();
    return _postItemStore!;
  }

  ConversationStore get conversationStore {
    _conversationStore ??= ConversationStore();
    return _conversationStore!;
  }

  MessengerStore get messengerStore {
    _messengerStore ??= MessengerStore(conversationStore);
    return _messengerStore!;
  }

  ChatStore get chatStore {
    _chatStore ??= ChatStore(conversationStore);
    return _chatStore!;
  }
  
  FirebasePresenceService get firebasePresenceService {
    _firebasePresenceService ??= FirebasePresenceService();
    return _firebasePresenceService!;
  }

  FirebaseChatService get firebaseChatService {
    _firebaseChatService ??= FirebaseChatService();
    return _firebaseChatService!;
  }
  
  CreatePostAdvancedOptionSettingStore get createPostAdvancedOptionSettingStore {
    _createPostAdvancedOptionSettingStore ??= CreatePostAdvancedOptionSettingStore();
    return _createPostAdvancedOptionSettingStore!;
  }
  
  MediaStore get mediaStore {
    _mediaStore ??= MediaStore(createPostStore);
    return _mediaStore!;
  }
  
  LinkPreviewStore get linkPreviewStore {
    _linkPreviewStore ??= LinkPreviewStore(createPostStore);
    return _linkPreviewStore!;
  }
  
  TextStore get textStore {
    _textStore ??= TextStore(createPostStore);
    return _textStore!;
  }
  
  ItemDetailStore get itemDetailStore {
    _itemDetailStore ??= ItemDetailStore(friendsStore);
    return _itemDetailStore!;
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
      // Dispose stores if they exist
      _dashBoardStore?.disposeAll();
      _profileStore?.disposeAll();
      _searchStore?.dispose(); // Use dispose() instead of disposeAll() for SearchStore
      _friendsStore?.disposeAll();
      _homeStore?.disposeAll();
      _createPostStore?.disposeAll();
      _postItemStore?.disposeAll();
      _mediaStore?.dispose();
      _linkPreviewStore?.dispose();
      _textStore?.dispose();
      _chatStore?.disposeAll();


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