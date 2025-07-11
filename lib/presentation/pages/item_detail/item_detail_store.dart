import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:mobx/mobx.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

part 'item_detail_store.g.dart';

class ItemDetailStore = _ItemDetailStore with _$ItemDetailStore;

abstract class _ItemDetailStore with Store {
  /// Controller
  final AutoScrollController scrollController = AutoScrollController(axis: Axis.vertical);

  /// Store
  final FriendsStore friendsStore = FriendsStore();

  ///

  @observable
  ObservableList<Map<String, dynamic>> listNameItemDetailsALL = ObservableList.of([
    {'name': REMOVE, 'image': ImagesPath.icUnfriend, 'valueNumber': 0},
    {'name': DENIED, 'image': ImagesPath.icUnfriend, 'valueNumber': 1},
    {'name': UNFOLLOW, 'image': ImagesPath.icUnFollow, 'valueNumber': 2},
    {'name': QUICK_SHARE, 'image': ImagesPath.icQuickShare, 'valueNumber': 3},
    {'name': CREATE_NEW_POST, 'image': ImagesPath.icCreateNewPost, 'valueNumber': 4},
    {'name': SHARE_WITH_FRIENDS, 'image': ImagesPath.icShareWithFriend, 'valueNumber': 5},
    {'name': SHARE_TO_PAGE, 'image': ImagesPath.icShareToPage, 'valueNumber': 6},
    {'name': SHARE_TO_GROUP, 'image': ImagesPath.icShareToGroup, 'valueNumber': 7},
    {'name': SEND_VIA_MESSAGE, 'image': ImagesPath.icSendViaMessage, 'valueNumber': 8},
    {'name': SWITCH_TO_ANOTHER_APP, 'image': ImagesPath.icSwitchToAnotherApp, 'valueNumber': 9},
    {'name': COPY_LINK, 'image': ImagesPath.icCopyLink, 'valueNumber': 10},
    {'name': ADD_TO_FOLDER, 'image': ImagesPath.icAddToFolder, 'valueNumber': 11},
    {'name': RENAME, 'image': ImagesPath.icRename, 'valueNumber': 12},
    {'name': PAIRING, 'image': ImagesPath.icPairing, 'valueNumber': 13},
    {'name': UNFRIEND, 'image': ImagesPath.icUnfriend, 'valueNumber': 14},
  ]);


  @action
  List<Map<String, dynamic>> getFilteredItems(String categoryName) {
    List<int> excludedValues = [];

    if (categoryName == ALL_FRIENDS) {
      excludedValues = [0, 1, 2];
    } else if (categoryName == SUGGESTIONS_FRIENDS) {
      excludedValues = [1, 2];
    } else if (categoryName == FRIEND_REQUESTS) {
      excludedValues = [0, 2];
    } else if (categoryName == FOLLOWING) {
      excludedValues = [0, 1];
    }

    return listNameItemDetailsALL
        .where((item) => !excludedValues.contains(item['valueNumber']))
        .toList();
  }

  @action
  void actionItemDetail({
    required String nameItemDetail,
    required String? requestId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }){
      if(nameItemDetail == DENIED){
         friendsStore.rejectFriendRequest(
             requestId: requestId ?? "",
             onSuccess: onSuccess,
             onError: onError
         );
      }
  }

}