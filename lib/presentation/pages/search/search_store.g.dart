// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchStore on _SearchStore, Store {
  late final _$searchTextAtom = Atom(
    name: '_SearchStore.searchText',
    context: context,
  );

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  late final _$hasTextAtom = Atom(
    name: '_SearchStore.hasText',
    context: context,
  );

  @override
  bool get hasText {
    _$hasTextAtom.reportRead();
    return super.hasText;
  }

  @override
  set hasText(bool value) {
    _$hasTextAtom.reportWrite(value, super.hasText, () {
      super.hasText = value;
    });
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
hasText: ${hasText}
    ''';
  }
}
