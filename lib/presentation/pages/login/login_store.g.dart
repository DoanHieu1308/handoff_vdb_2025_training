// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStore, Store {
  late final _$currentPageIndexAtom = Atom(
    name: '_LoginStore.currentPageIndex',
    context: context,
  );

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  late final _$isRememberAtom = Atom(
    name: '_LoginStore.isRemember',
    context: context,
  );

  @override
  bool get isRemember {
    _$isRememberAtom.reportRead();
    return super.isRemember;
  }

  @override
  set isRemember(bool value) {
    _$isRememberAtom.reportWrite(value, super.isRemember, () {
      super.isRemember = value;
    });
  }

  late final _$_LoginStoreActionController = ActionController(
    name: '_LoginStore',
    context: context,
  );

  @override
  void onChangePageIndex({required int index}) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.onChangePageIndex',
    );
    try {
      return super.onChangePageIndex(index: index);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRemember() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.setRemember',
    );
    try {
      return super.setRemember();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToForgotPassword() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.goToForgotPassword',
    );
    try {
      return super.goToForgotPassword();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
isRemember: ${isRemember}
    ''';
  }
}
