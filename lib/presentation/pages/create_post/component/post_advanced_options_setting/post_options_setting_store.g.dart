// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_options_setting_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostOptionsSettingStore on _PostOptionsSettingStore, Store {
  late final _$tagFriendListAtom = Atom(
    name: '_PostOptionsSettingStore.tagFriendList',
    context: context,
  );

  @override
  ObservableList<UserModel> get tagFriendList {
    _$tagFriendListAtom.reportRead();
    return super.tagFriendList;
  }

  @override
  set tagFriendList(ObservableList<UserModel> value) {
    _$tagFriendListAtom.reportWrite(value, super.tagFriendList, () {
      super.tagFriendList = value;
    });
  }

  late final _$friendListSearchAtom = Atom(
    name: '_PostOptionsSettingStore.friendListSearch',
    context: context,
  );

  @override
  List<UserModel> get friendListSearch {
    _$friendListSearchAtom.reportRead();
    return super.friendListSearch;
  }

  @override
  set friendListSearch(List<UserModel> value) {
    _$friendListSearchAtom.reportWrite(value, super.friendListSearch, () {
      super.friendListSearch = value;
    });
  }

  late final _$currentStatusAtom = Atom(
    name: '_PostOptionsSettingStore.currentStatus',
    context: context,
  );

  @override
  int get currentStatus {
    _$currentStatusAtom.reportRead();
    return super.currentStatus;
  }

  @override
  set currentStatus(int value) {
    _$currentStatusAtom.reportWrite(value, super.currentStatus, () {
      super.currentStatus = value;
    });
  }

  late final _$_PostOptionsSettingStoreActionController = ActionController(
    name: '_PostOptionsSettingStore',
    context: context,
  );

  @override
  void onChangedStatus({required int index}) {
    final _$actionInfo = _$_PostOptionsSettingStoreActionController.startAction(
      name: '_PostOptionsSettingStore.onChangedStatus',
    );
    try {
      return super.onChangedStatus(index: index);
    } finally {
      _$_PostOptionsSettingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getItemSearch() {
    final _$actionInfo = _$_PostOptionsSettingStoreActionController.startAction(
      name: '_PostOptionsSettingStore.getItemSearch',
    );
    try {
      return super.getItemSearch();
    } finally {
      _$_PostOptionsSettingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tagFriendList: ${tagFriendList},
friendListSearch: ${friendListSearch},
currentStatus: ${currentStatus}
    ''';
  }
}
