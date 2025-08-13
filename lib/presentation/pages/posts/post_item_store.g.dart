// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostItemStore on _PostItemStore, Store {
  late final _$hashtagsAtom = Atom(
    name: '_PostItemStore.hashtags',
    context: context,
  );

  @override
  ObservableList<String> get hashtags {
    _$hashtagsAtom.reportRead();
    return super.hashtags;
  }

  @override
  set hashtags(ObservableList<String> value) {
    _$hashtagsAtom.reportWrite(value, super.hashtags, () {
      super.hashtags = value;
    });
  }

  @override
  String toString() {
    return '''
hashtags: ${hashtags}
    ''';
  }
}
