// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ItemDetailStore on _ItemDetailStore, Store {
  late final _$listNameItemDetailsALLAtom = Atom(
    name: '_ItemDetailStore.listNameItemDetailsALL',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get listNameItemDetailsALL {
    _$listNameItemDetailsALLAtom.reportRead();
    return super.listNameItemDetailsALL;
  }

  @override
  set listNameItemDetailsALL(ObservableList<Map<String, dynamic>> value) {
    _$listNameItemDetailsALLAtom.reportWrite(
      value,
      super.listNameItemDetailsALL,
      () {
        super.listNameItemDetailsALL = value;
      },
    );
  }

  late final _$_ItemDetailStoreActionController = ActionController(
    name: '_ItemDetailStore',
    context: context,
  );

  @override
  List<Map<String, dynamic>> getFilteredItems(String categoryName) {
    final _$actionInfo = _$_ItemDetailStoreActionController.startAction(
      name: '_ItemDetailStore.getFilteredItems',
    );
    try {
      return super.getFilteredItems(categoryName);
    } finally {
      _$_ItemDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void actionItemDetail({
    required String nameItemDetail,
    required String? requestId,
    required dynamic Function() onSuccess,
    required dynamic Function(dynamic) onError,
  }) {
    final _$actionInfo = _$_ItemDetailStoreActionController.startAction(
      name: '_ItemDetailStore.actionItemDetail',
    );
    try {
      return super.actionItemDetail(
        nameItemDetail: nameItemDetail,
        requestId: requestId,
        onSuccess: onSuccess,
        onError: onError,
      );
    } finally {
      _$_ItemDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listNameItemDetailsALL: ${listNameItemDetailsALL}
    ''';
  }
}
