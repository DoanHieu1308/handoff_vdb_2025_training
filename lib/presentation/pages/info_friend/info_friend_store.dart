import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:mobx/mobx.dart';
part 'info_friend_store.g.dart';

class InfoFriendStore = _InfoFriendStore with _$InfoFriendStore;

abstract class _InfoFriendStore with Store {
  @observable
  int selectedFolderIndex = 0;

  @observable
  bool isLSeeMore = false;

  /// argument
  @observable
  UserModel? user;

  @observable
  String? status;

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

  ///
  /// get info user from friend item
  ///
  @action
  void initFromArguments(Map<String, dynamic> args) {
    user = args['user'] as UserModel?;
    status = args['status'] as String?;
  }
}