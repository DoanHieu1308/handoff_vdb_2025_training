import 'package:mobx/mobx.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  @observable
  int selectedFolderIndex = 0;

  @action
  void onChangedFolderIndexProfile({required int index}){
    if (index == selectedFolderIndex) return;
    selectedFolderIndex = index;
  }
}