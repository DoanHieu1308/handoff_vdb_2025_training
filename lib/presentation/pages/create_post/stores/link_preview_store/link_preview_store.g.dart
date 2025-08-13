// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_preview_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LinkPreviewStore on _LinkPreviewStore, Store {
  late final _$detectedLinkAtom = Atom(
    name: '_LinkPreviewStore.detectedLink',
    context: context,
  );

  @override
  String? get detectedLink {
    _$detectedLinkAtom.reportRead();
    return super.detectedLink;
  }

  @override
  set detectedLink(String? value) {
    _$detectedLinkAtom.reportWrite(value, super.detectedLink, () {
      super.detectedLink = value;
    });
  }

  late final _$isLoadingPreviewAtom = Atom(
    name: '_LinkPreviewStore.isLoadingPreview',
    context: context,
  );

  @override
  bool get isLoadingPreview {
    _$isLoadingPreviewAtom.reportRead();
    return super.isLoadingPreview;
  }

  @override
  set isLoadingPreview(bool value) {
    _$isLoadingPreviewAtom.reportWrite(value, super.isLoadingPreview, () {
      super.isLoadingPreview = value;
    });
  }

  late final _$debounceAtom = Atom(
    name: '_LinkPreviewStore.debounce',
    context: context,
  );

  @override
  Timer? get debounce {
    _$debounceAtom.reportRead();
    return super.debounce;
  }

  @override
  set debounce(Timer? value) {
    _$debounceAtom.reportWrite(value, super.debounce, () {
      super.debounce = value;
    });
  }

  late final _$previewDataAtom = Atom(
    name: '_LinkPreviewStore.previewData',
    context: context,
  );

  @override
  PostLinkMeta get previewData {
    _$previewDataAtom.reportRead();
    return super.previewData;
  }

  @override
  set previewData(PostLinkMeta value) {
    _$previewDataAtom.reportWrite(value, super.previewData, () {
      super.previewData = value;
    });
  }

  late final _$hasLinkAtom = Atom(
    name: '_LinkPreviewStore.hasLink',
    context: context,
  );

  @override
  bool get hasLink {
    _$hasLinkAtom.reportRead();
    return super.hasLink;
  }

  @override
  set hasLink(bool value) {
    _$hasLinkAtom.reportWrite(value, super.hasLink, () {
      super.hasLink = value;
    });
  }

  late final _$_LinkPreviewStoreActionController = ActionController(
    name: '_LinkPreviewStore',
    context: context,
  );

  @override
  void detectAndPreviewFirstLink(String text) {
    final _$actionInfo = _$_LinkPreviewStoreActionController.startAction(
      name: '_LinkPreviewStore.detectAndPreviewFirstLink',
    );
    try {
      return super.detectAndPreviewFirstLink(text);
    } finally {
      _$_LinkPreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
detectedLink: ${detectedLink},
isLoadingPreview: ${isLoadingPreview},
debounce: ${debounce},
previewData: ${previewData},
hasLink: ${hasLink}
    ''';
  }
}
