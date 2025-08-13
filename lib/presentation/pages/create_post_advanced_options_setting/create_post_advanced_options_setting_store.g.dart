// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_advanced_options_setting_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePostAdvancedOptionSettingStore
    on _CreatePostAdvancedOptionSettingStore, Store {
  late final _$tagFriendListAtom = Atom(
    name: '_CreatePostAdvancedOptionSettingStore.tagFriendList',
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
    name: '_CreatePostAdvancedOptionSettingStore.friendListSearch',
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
    name: '_CreatePostAdvancedOptionSettingStore.currentStatus',
    context: context,
  );

  @override
  String get currentStatus {
    _$currentStatusAtom.reportRead();
    return super.currentStatus;
  }

  @override
  set currentStatus(String value) {
    _$currentStatusAtom.reportWrite(value, super.currentStatus, () {
      super.currentStatus = value;
    });
  }

  late final _$listNameItemOptionAtom = Atom(
    name: '_CreatePostAdvancedOptionSettingStore.listNameItemOption',
    context: context,
  );

  @override
  ObservableList<PostOptionItem> get listNameItemOption {
    _$listNameItemOptionAtom.reportRead();
    return super.listNameItemOption;
  }

  @override
  set listNameItemOption(ObservableList<PostOptionItem> value) {
    _$listNameItemOptionAtom.reportWrite(value, super.listNameItemOption, () {
      super.listNameItemOption = value;
    });
  }

  late final _$_CreatePostAdvancedOptionSettingStoreActionController =
      ActionController(
        name: '_CreatePostAdvancedOptionSettingStore',
        context: context,
      );

  @override
  void onChangedStatus({required String status}) {
    final _$actionInfo = _$_CreatePostAdvancedOptionSettingStoreActionController
        .startAction(
          name: '_CreatePostAdvancedOptionSettingStore.onChangedStatus',
        );
    try {
      return super.onChangedStatus(status: status);
    } finally {
      _$_CreatePostAdvancedOptionSettingStoreActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  NameAndIcon nameAndIconFromStatus(String status) {
    final _$actionInfo = _$_CreatePostAdvancedOptionSettingStoreActionController
        .startAction(
          name: '_CreatePostAdvancedOptionSettingStore.nameAndIconFromStatus',
        );
    try {
      return super.nameAndIconFromStatus(status);
    } finally {
      _$_CreatePostAdvancedOptionSettingStoreActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void onTapOptionPost(BuildContext context, PostOptionType type) {
    final _$actionInfo = _$_CreatePostAdvancedOptionSettingStoreActionController
        .startAction(
          name: '_CreatePostAdvancedOptionSettingStore.onTapOptionPost',
        );
    try {
      return super.onTapOptionPost(context, type);
    } finally {
      _$_CreatePostAdvancedOptionSettingStoreActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void getItemSearch() {
    final _$actionInfo = _$_CreatePostAdvancedOptionSettingStoreActionController
        .startAction(
          name: '_CreatePostAdvancedOptionSettingStore.getItemSearch',
        );
    try {
      return super.getItemSearch();
    } finally {
      _$_CreatePostAdvancedOptionSettingStoreActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_CreatePostAdvancedOptionSettingStoreActionController
        .startAction(name: '_CreatePostAdvancedOptionSettingStore.reset');
    try {
      return super.reset();
    } finally {
      _$_CreatePostAdvancedOptionSettingStoreActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
tagFriendList: ${tagFriendList},
friendListSearch: ${friendListSearch},
currentStatus: ${currentStatus},
listNameItemOption: ${listNameItemOption}
    ''';
  }
}
