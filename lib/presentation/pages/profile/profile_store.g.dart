// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  late final _$selectedFolderIndexAtom = Atom(
    name: '_ProfileStore.selectedFolderIndex',
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
    name: '_ProfileStore.isLSeeMore',
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

  late final _$isLoadingAtom = Atom(
    name: '_ProfileStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_ProfileStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$logOutAsyncAction = AsyncAction(
    '_ProfileStore.logOut',
    context: context,
  );

  @override
  Future<void> logOut({required BuildContext context}) {
    return _$logOutAsyncAction.run(() => super.logOut(context: context));
  }

  late final _$goToFriendPageAsyncAction = AsyncAction(
    '_ProfileStore.goToFriendPage',
    context: context,
  );

  @override
  Future<void> goToFriendPage(BuildContext context) {
    return _$goToFriendPageAsyncAction.run(() => super.goToFriendPage(context));
  }

  late final _$_ProfileStoreActionController = ActionController(
    name: '_ProfileStore',
    context: context,
  );

  @override
  void onChangedFolderIndexProfile({required int index}) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
      name: '_ProfileStore.onChangedFolderIndexProfile',
    );
    try {
      return super.onChangedFolderIndexProfile(index: index);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedFolderIndex: ${selectedFolderIndex},
isLSeeMore: ${isLSeeMore},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
