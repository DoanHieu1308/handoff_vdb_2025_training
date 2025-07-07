// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendsStore on _FriendsStore, Store {
  late final _$selectedCategoryNameAtom = Atom(
    name: '_FriendsStore.selectedCategoryName',
    context: context,
  );

  @override
  String get selectedCategoryName {
    _$selectedCategoryNameAtom.reportRead();
    return super.selectedCategoryName;
  }

  @override
  set selectedCategoryName(String value) {
    _$selectedCategoryNameAtom.reportWrite(
      value,
      super.selectedCategoryName,
      () {
        super.selectedCategoryName = value;
      },
    );
  }

  late final _$_FriendsStoreActionController = ActionController(
    name: '_FriendsStore',
    context: context,
  );

  @override
  void setSelectedCategory(String name) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.setSelectedCategory',
    );
    try {
      return super.setSelectedCategory(name);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedCategoryName: ${selectedCategoryName}
    ''';
  }
}
