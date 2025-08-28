// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePostStore on _CreatePostStore, Store {
  late final _$isLoadingEditPostAtom =
      Atom(name: '_CreatePostStore.isLoadingEditPost', context: context);

  @override
  bool get isLoadingEditPost {
    _$isLoadingEditPostAtom.reportRead();
    return super.isLoadingEditPost;
  }

  @override
  set isLoadingEditPost(bool value) {
    _$isLoadingEditPostAtom.reportWrite(value, super.isLoadingEditPost, () {
      super.isLoadingEditPost = value;
    });
  }

  late final _$isReceivedValueAtom =
      Atom(name: '_CreatePostStore.isReceivedValue', context: context);

  @override
  bool get isReceivedValue {
    _$isReceivedValueAtom.reportRead();
    return super.isReceivedValue;
  }

  @override
  set isReceivedValue(bool value) {
    _$isReceivedValueAtom.reportWrite(value, super.isReceivedValue, () {
      super.isReceivedValue = value;
    });
  }

  late final _$_sharedTextAtom =
      Atom(name: '_CreatePostStore._sharedText', context: context);

  @override
  String? get _sharedText {
    _$_sharedTextAtom.reportRead();
    return super._sharedText;
  }

  @override
  set _sharedText(String? value) {
    _$_sharedTextAtom.reportWrite(value, super._sharedText, () {
      super._sharedText = value;
    });
  }

  late final _$initialChildSizeAtom =
      Atom(name: '_CreatePostStore.initialChildSize', context: context);

  @override
  double get initialChildSize {
    _$initialChildSizeAtom.reportRead();
    return super.initialChildSize;
  }

  @override
  set initialChildSize(double value) {
    _$initialChildSizeAtom.reportWrite(value, super.initialChildSize, () {
      super.initialChildSize = value;
    });
  }

  late final _$postMessageAtom =
      Atom(name: '_CreatePostStore.postMessage', context: context);

  @override
  String get postMessage {
    _$postMessageAtom.reportRead();
    return super.postMessage;
  }

  @override
  set postMessage(String value) {
    _$postMessageAtom.reportWrite(value, super.postMessage, () {
      super.postMessage = value;
    });
  }

  late final _$isPostSuccessAtom =
      Atom(name: '_CreatePostStore.isPostSuccess', context: context);

  @override
  bool get isPostSuccess {
    _$isPostSuccessAtom.reportRead();
    return super.isPostSuccess;
  }

  @override
  set isPostSuccess(bool value) {
    _$isPostSuccessAtom.reportWrite(value, super.isPostSuccess, () {
      super.isPostSuccess = value;
    });
  }

  late final _$listNameItemDraggableAtom =
      Atom(name: '_CreatePostStore.listNameItemDraggable', context: context);

  @override
  ObservableList<Map<String, dynamic>> get listNameItemDraggable {
    _$listNameItemDraggableAtom.reportRead();
    return super.listNameItemDraggable;
  }

  @override
  set listNameItemDraggable(ObservableList<Map<String, dynamic>> value) {
    _$listNameItemDraggableAtom.reportWrite(value, super.listNameItemDraggable,
        () {
      super.listNameItemDraggable = value;
    });
  }

  late final _$_CreatePostStoreActionController =
      ActionController(name: '_CreatePostStore', context: context);

  @override
  void onTapOptionDraggable(BuildContext context, int index) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.onTapOptionDraggable');
    try {
      return super.onTapOptionDraggable(context, index);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetPostForm() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.resetPostForm');
    try {
      return super.resetPostForm();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingEditPost: ${isLoadingEditPost},
isReceivedValue: ${isReceivedValue},
initialChildSize: ${initialChildSize},
postMessage: ${postMessage},
isPostSuccess: ${isPostSuccess},
listNameItemDraggable: ${listNameItemDraggable}
    ''';
  }
}
