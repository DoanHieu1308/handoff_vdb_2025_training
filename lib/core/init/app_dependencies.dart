import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/repositories/auth_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/profile_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_store.dart';

/// Global access to app dependencies
class AppDependencies {
  static AppInit get _appInit => AppInit.instance;

  // Shared Preferences
  static get sharedPreferences => _appInit.sharedPreferenceHelper;

  // Repositories
  static AuthRepository get authRepository => _appInit.authRepository;
  static FriendRepository get friendRepository => _appInit.friendRepository;
  static UserRepository get userRepository => _appInit.userRepository;

  // Stores
  static LoginStore get loginStore => _appInit.loginStore;
  static SignUpStore get signUpStore => _appInit.signUpStore;
  static DashBoardStore get dashBoardStore => _appInit.dashBoardStore;
  static ProfileStore get profileStore => _appInit.profileStore;
  static FriendsStore get friendStore => _appInit.friendsStore;
  static SearchStore get searchStore => _appInit.searchStore;
  static InfoFriendStore get infoFriendStore => _appInit.infoFriendStore;

  // Dio Client
  static get dioClient => _appInit.dioClient;

  /// Get all stores as a map
  static Map<String, dynamic> get allStores => _appInit.getStores();

  /// Get all repositories as a map
  static Map<String, dynamic> get allRepositories => _appInit.getRepositories();

  /// Dispose all resources
  static void dispose() {
    _appInit.dispose();
  }
} 