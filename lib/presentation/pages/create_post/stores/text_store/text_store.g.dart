// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TextStore on _TextStore, Store {
  late final _$hashtagsAtom =
      Atom(name: '_TextStore.hashtags', context: context);

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

  late final _$hasTextAtom = Atom(name: '_TextStore.hasText', context: context);

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

  late final _$fellingTextAtom =
      Atom(name: '_TextStore.fellingText', context: context);

  @override
  String get fellingText {
    _$fellingTextAtom.reportRead();
    return super.fellingText;
  }

  @override
  set fellingText(String value) {
    _$fellingTextAtom.reportWrite(value, super.fellingText, () {
      super.fellingText = value;
    });
  }

  @override
  String toString() {
    return '''
hashtags: ${hashtags},
hasText: ${hasText},
fellingText: ${fellingText}
    ''';
  }
}
