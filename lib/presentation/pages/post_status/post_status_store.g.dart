// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_status_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostStatusStore on _PostStatusStore, Store {
  late final _$listFileAtom = Atom(
    name: '_PostStatusStore.listFile',
    context: context,
  );

  @override
  ObservableList<File> get listFile {
    _$listFileAtom.reportRead();
    return super.listFile;
  }

  @override
  set listFile(ObservableList<File> value) {
    _$listFileAtom.reportWrite(value, super.listFile, () {
      super.listFile = value;
    });
  }

  @override
  String toString() {
    return '''
listFile: ${listFile}
    ''';
  }
}
