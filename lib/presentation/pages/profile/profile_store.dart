import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/repositories/auth_repository.dart';
import 'package:mobx/mobx.dart';

import '../../../core/shared_pref/shared_preference_helper.dart';
import '../../../data/model/response/user_model.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  /// Repository
  final _userRepository = AppInit.instance.userRepository;
  final _authRepository =  AppInit.instance.authRepository;

  /// Store
  final friendsStore = AppInit.instance.friendsStore;

  /// SharePreference
  final _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Value
  @observable
  int selectedFolderIndex = 0;

  @observable
  bool isLSeeMore = false;

  @observable
  bool isLoading = false;

  /// Accept
  @observable
  UserModel userProfile = UserModel();

  /// Text error
  @observable
  String? errorMessage;

  ///
  /// Init
  ///
  _ProfileStore() {
    _init();
  }

  ///
  /// Init
  ///
  Future<void> _init() async {
  }

  ///
  /// Dispose
  ///
  void disposeAll() {
    friendsStore.disposeAll();
  }

  ///
  /// change folder
  ///
  @action
  void onChangedFolderIndexProfile({required int index}){
    if (index == selectedFolderIndex) return;
    selectedFolderIndex = index;
  }

  ///
  /// Logout
  ///
  @action
  Future<void> logOut({
    required BuildContext context
  }) async {
    isLoading = true;
    await _authRepository.logout(
        onSuccess: () async {
          isLoading = false;

          await _sharedPreferenceHelper.clearAuthData();
          print("accesstoken: ${_sharedPreferenceHelper.getAccessToken}");

          await AppInit.instance.dioClient.cookieJar.deleteAll();
          friendsStore.friendListSuggestionStatus.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đăng xuất thành công"),
              duration: Duration(milliseconds: 1000),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
            ),
          );

          await Future.delayed(Duration(milliseconds: 100));

          Navigator.of(context).pushNamed(AuthRouters.LOGIN);
        },
        onError: (error){
          isLoading = false;
          errorMessage = error.toString();
          print(errorMessage ?? "An error occurred");
        }
    );
  }

  ///
  /// Go to all friend
  ///
  @action
  Future<void> goToFriendPage(BuildContext context) async {
    // Tắt bàn phím trước khi navigate
    FocusScope.of(context).unfocus();
    
    // Clear search text
    friendsStore.searchCtrl.textEditingController.clear();
    friendsStore.searchCtrl.searchText = '';
    
    friendsStore.getAllFriends();
    Navigator.of(
      context,
    ).pushNamed(AuthRouters.FRIENDS);
  }

  ///
  /// Get All Friends
  ///
  Future<void> getUserProfile() async {
    String userId = _sharedPreferenceHelper.getIdUser.toString();
    await _userRepository.getUserProfile(
        userId: userId,
        onSuccess: (data) {
          userProfile = data;
          print(userProfile.name);
        },
        onError: (error){
          print("loi o all friend $error");
        }
    );
  }
}