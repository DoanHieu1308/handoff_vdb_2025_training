import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:mobx/mobx.dart';

import '../profile/pages/profile_page/profile_store.dart';
part 'dash_board_store.g.dart';

class DashBoardStore = _DashBoardStore with _$DashBoardStore;

abstract class _DashBoardStore with Store {
  /// Store
  final FriendsStore friendsStore = AppInit.instance.friendsStore;
  final ProfileStore profileStore = AppInit.instance.profileStore;

  @observable
  int currentIndex = 0;

  ///
  /// Init
  ///
  Future<void> init() async {
    friendsStore.getAllFriends();
    friendsStore.selectedCategoryName = ALL_FRIENDS;
    profileStore.getUserProfile();
  }


  ///
  /// Dispose
  ///
  void disposeAll() {
    friendsStore.disposeAll();
  }


  @action
  void onChangedDashboardPage({required int index}){
    if (index == currentIndex) return;
    currentIndex = index;
  }


}