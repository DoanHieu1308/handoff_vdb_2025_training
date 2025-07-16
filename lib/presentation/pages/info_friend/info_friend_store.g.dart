// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_friend_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InfoFriendStore on _InfoFriendStore, Store {
  late final _$selectedFolderIndexAtom = Atom(
    name: '_InfoFriendStore.selectedFolderIndex',
    context: context,
  );

  @override
  int get selectedFolderIndex {
    _$selectedFolderIndexAtom.reportRead();
    return super.selectedFolderIndex;
  }

  @override
  set selectedFolderIndex(int value) {
    _$selectedFolderIndexAtom.reportWrite(value, super.selectedFolderIndex, () {
      super.selectedFolderIndex = value;
    });
  }

  late final _$isLSeeMoreAtom = Atom(
    name: '_InfoFriendStore.isLSeeMore',
    context: context,
  );

  @override
  bool get isLSeeMore {
    _$isLSeeMoreAtom.reportRead();
    return super.isLSeeMore;
  }

  @override
  set isLSeeMore(bool value) {
    _$isLSeeMoreAtom.reportWrite(value, super.isLSeeMore, () {
      super.isLSeeMore = value;
    });
  }

  late final _$userAtom = Atom(name: '_InfoFriendStore.user', context: context);

  @override
  UserModel? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$statusAtom = Atom(
    name: '_InfoFriendStore.status',
    context: context,
  );

  @override
  String? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$_InfoFriendStoreActionController = ActionController(
    name: '_InfoFriendStore',
    context: context,
  );

  @override
  void onChangedFolderIndexProfile({required int index}) {
    final _$actionInfo = _$_InfoFriendStoreActionController.startAction(
      name: '_InfoFriendStore.onChangedFolderIndexProfile',
    );
    try {
      return super.onChangedFolderIndexProfile(index: index);
    } finally {
      _$_InfoFriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initFromArguments(Map<String, dynamic> args) {
    final _$actionInfo = _$_InfoFriendStoreActionController.startAction(
      name: '_InfoFriendStore.initFromArguments',
    );
    try {
      return super.initFromArguments(args);
    } finally {
      _$_InfoFriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedFolderIndex: ${selectedFolderIndex},
isLSeeMore: ${isLSeeMore},
user: ${user},
status: ${status}
    ''';
  }
}
