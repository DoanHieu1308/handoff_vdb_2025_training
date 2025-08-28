// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  late final _$showAutoscrollAtom =
      Atom(name: '_ChatStore.showAutoscroll', context: context);

  @override
  bool get showAutoscroll {
    _$showAutoscrollAtom.reportRead();
    return super.showAutoscroll;
  }

  @override
  set showAutoscroll(bool value) {
    _$showAutoscrollAtom.reportWrite(value, super.showAutoscroll, () {
      super.showAutoscroll = value;
    });
  }

  late final _$isAssistantFromHistoryAtom =
      Atom(name: '_ChatStore.isAssistantFromHistory', context: context);

  @override
  bool get isAssistantFromHistory {
    _$isAssistantFromHistoryAtom.reportRead();
    return super.isAssistantFromHistory;
  }

  @override
  set isAssistantFromHistory(bool value) {
    _$isAssistantFromHistoryAtom
        .reportWrite(value, super.isAssistantFromHistory, () {
      super.isAssistantFromHistory = value;
    });
  }

  late final _$isHasInputAtom =
      Atom(name: '_ChatStore.isHasInput', context: context);

  @override
  bool get isHasInput {
    _$isHasInputAtom.reportRead();
    return super.isHasInput;
  }

  @override
  set isHasInput(bool value) {
    _$isHasInputAtom.reportWrite(value, super.isHasInput, () {
      super.isHasInput = value;
    });
  }

  @override
  String toString() {
    return '''
showAutoscroll: ${showAutoscroll},
isAssistantFromHistory: ${isAssistantFromHistory},
isHasInput: ${isHasInput}
    ''';
  }
}
