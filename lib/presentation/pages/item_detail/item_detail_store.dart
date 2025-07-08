import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:mobx/mobx.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

part 'item_detail_store.g.dart';

class ItemDetailStore = _ItemDetailStore with _$ItemDetailStore;

abstract class _ItemDetailStore with Store {
  /// Controller
  final AutoScrollController scrollController = AutoScrollController(axis: Axis.vertical);

  @observable
  ObservableList<Map<String, dynamic>> listNameItemDetailsALL = ObservableList.of([
    {'name': 'Remove', 'image': ImagesPath.icUnfriend, 'valueNumber': 0},
    {'name': 'Denied', 'image': ImagesPath.icUnfriend, 'valueNumber': 1},
    {'name': 'Unfollow', 'image': ImagesPath.icUnFollow, 'valueNumber': 2},
    {'name': 'Quick share', 'image': ImagesPath.icQuickShare, 'valueNumber': 3},
    {'name': 'Creat new post', 'image': ImagesPath.icCreateNewPost, 'valueNumber': 4},
    {'name': 'Share with friends', 'image': ImagesPath.icShareWithFriend, 'valueNumber': 5},
    {'name': 'Share to page', 'image': ImagesPath.icShareToPage, 'valueNumber': 6},
    {'name': 'Share to group', 'image': ImagesPath.icShareToGroup, 'valueNumber': 7},
    {'name': 'Send via message', 'image': ImagesPath.icSendViaMessage, 'valueNumber': 8},
    {'name': 'Switch to another app', 'image': ImagesPath.icSwitchToAnotherApp, 'valueNumber': 9},
    {'name': 'Copy link', 'image': ImagesPath.icCopyLink, 'valueNumber': 10},
    {'name': 'Add to folder', 'image': ImagesPath.icAddToFolder, 'valueNumber': 11},
    {'name': 'Rename', 'image': ImagesPath.icRename, 'valueNumber': 12},
    {'name': 'Pairing', 'image': ImagesPath.icPairing, 'valueNumber': 13},
    {'name': 'Unfriend', 'image': ImagesPath.icUnfriend, 'valueNumber': 14},
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

}