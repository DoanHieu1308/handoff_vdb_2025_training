import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../data/model/post/post_output_model.dart';
import '../../../../../data/model/response/user_model.dart';


part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  /// Repository
  final _userRepository = AppInit.instance.userRepository;
  final _authRepository =  AppInit.instance.authRepository;
  final _postRepository = AppInit.instance.postRepository;

  /// Store
  final friendsStore = AppInit.instance.friendsStore;
  DashBoardStore get dashBoardStore => AppInit.instance.dashBoardStore;

  /// Controller
  final RefreshController refreshController = RefreshController(initialRefresh: false);

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

  /// Post
  @observable
  ObservableList<PostOutputModel> posts = ObservableList();
  @observable
  int currentPage = 1;
  @observable
  bool hasMore = true;

  ///
  /// Init
  ///
  Future<void> init() async {
    loadInitialPostsByUserId();
  }

  ///
  /// Dispose
  ///
  void disposeAll() {
    friendsStore.disposeAll();
    refreshController.dispose();
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

          dashBoardStore.currentIndex = 0;

          print("${dashBoardStore.currentIndex}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đăng xuất thành công"),
              duration: Duration(milliseconds: 1000),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
            ),
          );

          await Future.delayed(Duration(milliseconds: 200));

          context.go(AuthRoutes.LOGIN);
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
    context.push(AuthRoutes.FRIENDS);
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

  ///
  /// Get list post by Userid
  ///
  Future<void> loadInitialPostsByUserId() async {
    currentPage = 1;
    hasMore = true;

    final userId = _sharedPreferenceHelper.getIdUser;
    if (userId == null || userId.isEmpty) {
      return;
    }

    await _postRepository.getPostsByUserId(
      userId: userId,
      page: currentPage,
      onSuccess: (result) {
        posts = ObservableList.of(result.data);

        hasMore = currentPage < result.pagination.totalPages;
        refreshController.refreshCompleted();
        refreshController.loadComplete();
      },
      onError: (error) {
        refreshController.refreshFailed();
      },
    );
  }

  Future<void> loadMorePostsByUserId() async {
    if (!hasMore) {
      refreshController.loadNoData();
      return;
    }

    final userId = _sharedPreferenceHelper.getIdUser;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final nextPage = currentPage + 1;

    await _postRepository.getPostsByUserId(
      userId: userId,
      page: nextPage,
      onSuccess: (result) {
        posts.addAll(result.data);
        currentPage = result.pagination.page;
        hasMore = currentPage < result.pagination.totalPages;

        if (hasMore) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData(); // Đã hết trang
        }
      },
      onError: (error) {
        refreshController.loadFailed();
      },
    );
  }
}