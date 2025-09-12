import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';
import 'package:mobx/mobx.dart';

import '../friends/friends_store.dart';

part 'conversation_store.g.dart';

class ConversationStore = _ConversationStore with _$ConversationStore;

abstract class _ConversationStore with Store {
  /// Store
  ProfileStore profileStore = AppInit.instance.profileStore;
  FriendsStore friendsStore = AppInit.instance.friendsStore;

  /// Value
  @observable
  int currentIndex = 0;

  @action
  void onChangedDashboardPage({required int index}){
    if (index == currentIndex) return;
    currentIndex = index;
  }
}