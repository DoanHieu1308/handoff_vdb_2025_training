import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/data/model/response/friend_profile_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/init/app_init.dart';
import '../../../data/model/post/post_output_model.dart';
part 'info_friend_store.g.dart';

class InfoFriendStore = _InfoFriendStore with _$InfoFriendStore;

abstract class _InfoFriendStore with Store {
  /// store
  FriendsStore get friendsStore => AppInit.instance.friendsStore;

  /// Controller
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  /// SharePreference
  final _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Repository
  final _userRepository = AppInit.instance.userRepository;
  final _followRepository = AppInit.instance.followRepository;
  final _postRepository = AppInit.instance.postRepository;

  /// Profile friend
  @observable
  FriendProfileModel profileFriend = FriendProfileModel();
  @observable
  int selectedFolderIndex = 0;
  @observable
  bool isLSeeMore = false;

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
  }


  ///
  /// Dispose
  ///
  void disposeAll() {}

  ///
  /// Change folder index profile
  ///
  @action
  void onChangedFolderIndexProfile({required int index}){
    if (index == selectedFolderIndex) return;
    selectedFolderIndex = index;
  }

  ///---------------------------------------------------------------
  /// Get All Friends
  ///
  Future<void> getFriendProfile({
    required String friendId
  }) async {
    print("get all friend access __${_sharedPreferenceHelper.getAccessToken}");
    // Debug: Check token before making request
    await _userRepository.getFriendProfile(
        userId: friendId,
        onSuccess: (data) {
          profileFriend = data;
          print("name: ${profileFriend.user?.name}");
        },
        onError: (error){
          print("loi o all friend $error");
        }
    );
  }

  ///--------------------------------------------------------
  ///  follow request
  ///
  Future<void> handleFollowRequest({
    required String friendId,
    required BuildContext context,
  }) async {

    await _followRepository.followFriend(
        friendId: friendId,
        onSuccess: () {
          profileFriend = profileFriend.copyWith(isFollowing: true);
        },
        onError: (error){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)));
        }
    );
  }

  ///--------------------------------------------------------
  ///  follow request
  ///
  Future<void> handleUnFollowRequest({
    required String friendId,
    required BuildContext context,
  }) async {

    await _followRepository.unfollowFriend(
        friendId: friendId,
        onSuccess: () {
          profileFriend = profileFriend.copyWith(isFollowing: false);
        },
        onError: (error){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)));
        }
    );
  }


  ///--------------------------------------------------------
  ///  get post by userId
  ///
  Future<void> getPostsOfFriendByUserId({
    required String userId
  }) async {
    currentPage = 1;
    hasMore = true;

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

  Future<void> loadMorePostsOfFriendByUserId({
    required String userId
  }) async {
    if (!hasMore) {
      refreshController.loadNoData();
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
          refreshController.loadNoData();
        }
      },
      onError: (error) {
        refreshController.loadFailed();
      },
    );
  }

}