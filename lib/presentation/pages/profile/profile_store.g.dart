// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  late final _$selectedFolderIndexAtom =
      Atom(name: '_ProfileStore.selectedFolderIndex', context: context);

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

  late final _$_ProfileStoreActionController =
      ActionController(name: '_ProfileStore', context: context);

  @override
  void onChangedFolderIndexProfile({required int index}) {
    final _$actionInfo = _$_ProfileStoreActionController.startAction(
        name: '_ProfileStore.onChangedFolderIndexProfile');
    try {
      return super.onChangedFolderIndexProfile(index: index);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedFolderIndex: ${selectedFolderIndex}
    ''';
  }
}
