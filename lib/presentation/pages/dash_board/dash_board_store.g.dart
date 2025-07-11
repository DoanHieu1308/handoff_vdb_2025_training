// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dash_board_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashBoardStore on _DashBoardStore, Store {
  late final _$currentIndexAtom = Atom(
    name: '_DashBoardStore.currentIndex',
    context: context,
  );

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_DashBoardStore.isLoading',
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

  late final _$userProfileAtom = Atom(
    name: '_DashBoardStore.userProfile',
    context: context,
  );

  @override
  UserModel get userProfile {
    _$userProfileAtom.reportRead();
    return super.userProfile;
  }

  @override
  set userProfile(UserModel value) {
    _$userProfileAtom.reportWrite(value, super.userProfile, () {
      super.userProfile = value;
    });
  }

  late final _$_DashBoardStoreActionController = ActionController(
    name: '_DashBoardStore',
    context: context,
  );

  @override
  void onChangedDashboardPage({required int index}) {
    final _$actionInfo = _$_DashBoardStoreActionController.startAction(
      name: '_DashBoardStore.onChangedDashboardPage',
    );
    try {
      return super.onChangedDashboardPage(index: index);
    } finally {
      _$_DashBoardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex},
isLoading: ${isLoading},
userProfile: ${userProfile}
    ''';
  }
}
