import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:mobx/mobx.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../core/enums/enums.dart';
import '../../../data/model/post_option/post_option_item.dart';
import '../profile/pages/profile_page/profile_store.dart';

part 'create_post_advanced_options_setting_store.g.dart';

class CreatePostAdvancedOptionSettingStore = _CreatePostAdvancedOptionSettingStore with _$CreatePostAdvancedOptionSettingStore;

abstract class _CreatePostAdvancedOptionSettingStore with Store {
  /// Store
  final FriendsStore friendsStore = AppInit.instance.friendsStore;
  final SearchStore searchStore = AppInit.instance.searchStore;
  final ProfileStore profileStore = AppInit.instance.profileStore;

  /// Tag friend
  @observable
  ObservableList<UserModel> tagFriendList = ObservableList.of([]);

  /// Search
  @observable
  List<UserModel> friendListSearch = [];

  ///
  @observable
  String currentStatus = PUBLIC;

  /// Init
  Future<void> init() async {
  }

  /// Change status
  @action
  void onChangedStatus({required String status}){
    if (status == currentStatus) return;
    currentStatus = status;
  }

  /// List item detail all
  @observable
  ObservableList<PostOptionItem> listNameItemOption = ObservableList.of([
    PostOptionItem(type: PostOptionType.onlyMe, name: 'Công khai', icon: ImagesPath.icGlobe),
    PostOptionItem(type: PostOptionType.album, name: 'Album', icon: ImagesPath.icAdd),
    PostOptionItem(type: PostOptionType.instagram, name: 'Đang tắt', icon: ImagesPath.icInstagram),
    PostOptionItem(type: PostOptionType.threads, name: 'Đang tắt ', icon: ImagesPath.icThreads),
    PostOptionItem(type: PostOptionType.label, name: 'Nhãn AL đang tắt', icon: ImagesPath.icAdd),
  ]);

  /// Change
  @action
  NameAndIcon nameAndIconFromStatus(String status) {
    switch (status) {
      case PUBLIC:
        return NameAndIcon('Công khai', ImagesPath.icGlobe);
      case PRIVATE:
        return NameAndIcon('Chỉ mình tôi', ImagesPath.icLock);
      case FRIEND:
        return NameAndIcon('Chỉ bạn bè', ImagesPath.icFriends);
      default:
        return NameAndIcon('Không xác định', ImagesPath.icUnfriend);
    }
  }

  /// OnTap option draggable
  @action
  void onTapOptionPost(BuildContext context, PostOptionType type) {
    final item = listNameItemOption.firstWhere((e) => e.type == type);
    switch (type) {
      case PostOptionType.onlyMe:
        context.push(AuthRoutes.STATUS_POST);
        break;
      case PostOptionType.album:
        break;
      case PostOptionType.instagram:
        break;
      case PostOptionType.threads:
        break;
      case PostOptionType.label:
        break;
      default:
        break;
    }
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

  @action
  void reset() {
    tagFriendList.clear();
    currentStatus = PUBLIC;
  }

}

class NameAndIcon {
  final String name;
  final String icon;
  NameAndIcon(this.name, this.icon);
}