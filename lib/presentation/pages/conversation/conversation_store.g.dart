// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConversationStore on _ConversationStore, Store {
  late final _$currentIndexAtom =
      Atom(name: '_ConversationStore.currentIndex', context: context);

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

  late final _$_ConversationStoreActionController =
      ActionController(name: '_ConversationStore', context: context);

  @override
  void onChangedDashboardPage({required int index}) {
    final _$actionInfo = _$_ConversationStoreActionController.startAction(
        name: '_ConversationStore.onChangedDashboardPage');
    try {
      return super.onChangedDashboardPage(index: index);
    } finally {
      _$_ConversationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentIndex: ${currentIndex}
    ''';
  }
}
