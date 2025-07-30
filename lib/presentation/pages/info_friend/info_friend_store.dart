import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/data/model/response/friend_profile_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/follow_repository.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:mobx/mobx.dart';

import '../../../core/init/app_init.dart';
import '../../../core/utils/app_constants.dart';
part 'info_friend_store.g.dart';

class InfoFriendStore = _InfoFriendStore with _$InfoFriendStore;

abstract class _InfoFriendStore with Store {
  /// store
  // Lazy initialization to break circular dependency
  FriendsStore get friendsStore => AppInit.instance.friendsStore;

  /// SharePreference
  final _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Repository
  late final UserRepository _userRepository;
  late final FollowRepository _followRepository;

  /// Profile friend
  @observable
  FriendProfileModel profileFriend = FriendProfileModel();

  @observable
  int selectedFolderIndex = 0;

  @observable
  bool isLSeeMore = false;


  ///
  /// Init
  ///
  _InfoFriendStore(){
    _init();
  }
  Future<void> _init() async {
    _userRepository = UserRepository();
    _followRepository = AppInit.instance.followRepository;
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
}