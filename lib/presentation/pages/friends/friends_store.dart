import 'package:mobx/mobx.dart';

part 'friends_store.g.dart';

class FriendsStore = _FriendsStore with _$FriendsStore;

abstract class _FriendsStore with Store {
  @observable
  String selectedCategoryName = "All";

  @action
  void setSelectedCategory(String name) {
    selectedCategoryName = name;
  }
}