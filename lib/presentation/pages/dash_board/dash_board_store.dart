import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';

import '../../../core/shared_pref/shared_preference_helper.dart';
part 'dash_board_store.g.dart';

class DashBoardStore = _DashBoardStore with _$DashBoardStore;

abstract class _DashBoardStore with Store {
  /// Repository
  final UserRepository _userRepository = UserRepository();

  /// SharePreference
  SharedPreferenceHelper? _sharedPreferenceHelper;

  @observable
  int currentIndex = 1;

  @observable
  bool isLoading = false;

  /// Accept
  @observable
  UserModel userProfile = UserModel();


  ///
  /// Init
  ///
  _DashBoardStore() {
    _init();
  }
  Future<void> _init() async {
    _sharedPreferenceHelper = SharedPreferenceHelper.instance;
  }


  @action
  void onChangedDashboardPage({required int index}){
    if (index == currentIndex) return;
    currentIndex = index;
  }

  ///
  /// Get All Friends
  ///
  Future<void> getUserProfile() async {
    isLoading = true;

    // Debug: Check token before making request
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;

    print("=== Debug Token ===");
    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");
    print("Is Token Empty: ${accessToken == null || accessToken.isEmpty}");

    await _userRepository.getUserProfile(
        onSuccess: (data) {
          userProfile = data;

          print(userProfile.name);
          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o all friend $error");
        }
    );
  }
}