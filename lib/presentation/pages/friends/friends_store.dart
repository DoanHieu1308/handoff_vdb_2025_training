import 'package:handoff_vdb_2025/data/model/friend/friend_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_request_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:mobx/mobx.dart';
import '../../../core/shared_pref/shared_preference_helper.dart';
import '../../../data/data_source/dio/dio_client.dart';

part 'friends_store.g.dart';

class FriendsStore = _FriendsStore with _$FriendsStore;

abstract class _FriendsStore with Store {
  late final DioClient _dio;

  /// Repository
  final FriendRepository _friendRepository = FriendRepository();

  /// SharePreference
  SharedPreferenceHelper? _sharedPreferenceHelper;

  @observable
  String selectedCategoryName = "All";

  @observable
  bool isLoading = false;

  @observable
  List<UserModel> friendList = [];

  @observable
  List<FriendRequestModel> friendListRequests = [];

  @observable
  List<UserModel> friendListPending = [];

  /// Accept
  @observable
  FriendModel acceptFriend = FriendModel();

  @observable
  ObservableMap<String, bool> acceptedFriends = ObservableMap<String, bool>();

  /// Reject
  @observable
  FriendModel rejectFriend = FriendModel();

  ///
  /// Init
  ///
  _FriendsStore() {
     _init();
  }
  Future<void> _init() async {
    _dio = DioClient();

    // Initialize SharedPreferences using singleton
    _sharedPreferenceHelper = SharedPreferenceHelper.instance;
  }

  ///
  /// Dispose
  ///
  void disposeAll() {

  }

  ///
  /// Selected Category
  ///
  @action
  void setSelectedCategory(String name) {
    selectedCategoryName = name;
  }

  ///
  /// Get All Friends
  ///
  Future<void> getAllFriends() async {
     isLoading = true;
     
     // Debug: Check token before making request
     final accessToken = _sharedPreferenceHelper?.getAccessToken;
     final refreshToken = _sharedPreferenceHelper?.getRefreshToken;
     
     print("=== Debug Token ===");
     print("Access Token: $accessToken");
     print("Refresh Token: $refreshToken");
     print("Is Token Empty: ${accessToken == null || accessToken.isEmpty}");
     
     await _friendRepository.getAllFriend(
         onSuccess: (list) {
           friendList = list;

           print(friendList[0].name);
           isLoading = false;
         },
         onError: (error){
           isLoading = false;
           print("loi o all friend $error");
         }
     );
  }

  ///
  /// Get All Friends Requests
  ///
  Future<void> getAllFriendsRequests() async {
    isLoading = true;

    // Debug: Check token before making request
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;

    print("=== Debug Token ===");
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    print("Is Token Empty: ${accessToken == null || accessToken.isEmpty}");

    await _friendRepository.getAllFriendRequests(
        onSuccess: (list) {
          friendListRequests = list;

          print(friendListRequests[0].fromUser?.name);

          friendListPending = friendListRequests
              .map((item) => item.fromUser!)
              .toList();

          print(friendListPending[0].name);
          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
        }
    );
  }

  ///
  /// Get All Friends Requests
  ///
  Future<void> acceptFriendRequest({
    required String requestId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    isLoading = true;
    // Debug: Check token before making request
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;

    print("=== Debug Token ===");
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    print("Is Token Empty: ${accessToken == null || accessToken.isEmpty}");

    await _friendRepository.acceptFriendRequest(
        requestId: requestId,
        onSuccess: (data) {
          acceptFriend = data;
          print("accept: ${acceptFriend.toUser}");
          isLoading = false;
          onSuccess();
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
          onError(error);
        }
    );
  }

  //
  @action
  void markFriendAccepted(String friendId) {
    acceptedFriends[friendId] = true;
  }

  ///
  /// Get All Friends Requests
  ///
  Future<void> rejectFriendRequest({
    required String requestId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    isLoading = true;
    // Debug: Check token before making request
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;

    print("=== Debug Token ===");
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    print("Is Token Empty: ${accessToken == null || accessToken.isEmpty}");

    await _friendRepository.rejectFriendRequest(
        requestId: requestId,
        onSuccess: (data) {
          rejectFriend = data;
          print("accept: ${rejectFriend.toUser}");
          isLoading = false;
          onSuccess();
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
          onError(error);
        }
    );
  }

  ///
  /// Kiểm tra trạng thái đăng nhập
  ///
  @action
  Future<void> checkLoginStatus() async {
    // await ensureInitialized();
    
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;
    final email = _sharedPreferenceHelper?.getEmail;
    
    print("=== Login Status ===");
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    print("Email: $email");
    print("Is Logged In: ${accessToken != null && accessToken.isNotEmpty}");
  }

  Future<void> testRefreshToken() async {
    await _dio.refreshToken();
  }

  ///
  /// Reset accepted friends status
  ///
  @action
  void resetAcceptedFriends() {
    acceptedFriends.clear();
  }

  ///
  /// Test lưu và đọc token
  ///
  @action
  Future<void> testTokenPersistence() async {
    // Test lưu token
    await _sharedPreferenceHelper?.setAccessToken("test_token_123");
    await _sharedPreferenceHelper?.setRefreshToken("test_refresh_456");
    await _sharedPreferenceHelper?.setEmail("test@example.com");
    
    print("=== Test lưu token ===");
    print("Đã lưu token thành công");
    
    // Test đọc token
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;
    final email = _sharedPreferenceHelper?.getEmail;
    
    print("=== Test đọc token ===");
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    print("Email: $email");
    
    // Test singleton
    final singletonInstance = SharedPreferenceHelper.instance;
    final singletonAccessToken = singletonInstance.getAccessToken;
    print("=== Test Singleton ===");
    print("Singleton Access Token: $singletonAccessToken");
    print("Tokens match: ${accessToken == singletonAccessToken}");
  }
}