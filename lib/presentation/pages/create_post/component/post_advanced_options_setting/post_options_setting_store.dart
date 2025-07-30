import 'dart:ui';

import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:mobx/mobx.dart';

part 'post_options_setting_store.g.dart';

class PostOptionsSettingStore = _PostOptionsSettingStore with _$PostOptionsSettingStore;

abstract class _PostOptionsSettingStore with Store {
  /// Store
  final CreatePostStore createPostStore = AppInit.instance.createPostStore;
  final FriendsStore friendsStore = AppInit.instance.friendsStore;
  final SearchStore searchStore = AppInit.instance.searchStore;

  /// Tag friend
  @observable
  ObservableList<UserModel> tagFriendList = ObservableList.of([]);

  /// Search
  @observable
  List<UserModel> friendListSearch = [];

  ///
  @observable
  int currentStatus = 0;

  _PostOptionsSettingStore(){
    init();
  }

  /// Init
  Future<void> init() async {
     print("${friendsStore.friendList.length}");
  }

  /// Change status
  @action
  void onChangedStatus({required int index}){
    if (index == currentStatus) return;
    currentStatus = index;
  }

  /// -----------------------------------------------------------
  /// Searching
  ///
  @action
  void getItemSearch() {
    friendListSearch.clear();
    final lowerSearch = searchStore.searchText.toLowerCase();

    for (final item in friendsStore.friendList) {
      final name = item.name;
      if (name != null && name.toLowerCase().contains(lowerSearch)) {
        friendListSearch.add(item);
      }
    }
  }
}