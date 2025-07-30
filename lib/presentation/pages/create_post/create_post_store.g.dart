// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePostStore on _CreatePostStore, Store {
  late final _$listFileAtom = Atom(
    name: '_CreatePostStore.listFile',
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

  late final _$isVideoAtom = Atom(
    name: '_CreatePostStore.isVideo',
    context: context,
  );

  @override
  bool get isVideo {
    _$isVideoAtom.reportRead();
    return super.isVideo;
  }

  @override
  set isVideo(bool value) {
    _$isVideoAtom.reportWrite(value, super.isVideo, () {
      super.isVideo = value;
    });
  }

  late final _$videoControllerAtom = Atom(
    name: '_CreatePostStore.videoController',
    context: context,
  );

  @override
  VideoPlayerController? get videoController {
    _$videoControllerAtom.reportRead();
    return super.videoController;
  }

  @override
  set videoController(VideoPlayerController? value) {
    _$videoControllerAtom.reportWrite(value, super.videoController, () {
      super.videoController = value;
    });
  }

  late final _$fellingTextAtom = Atom(
    name: '_CreatePostStore.fellingText',
    context: context,
  );

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

  late final _$hasTextAtom = Atom(
    name: '_CreatePostStore.hasText',
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

  late final _$initialChildSizeAtom = Atom(
    name: '_CreatePostStore.initialChildSize',
    context: context,
  );

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

  late final _$hasImageAtom = Atom(
    name: '_CreatePostStore.hasImage',
    context: context,
  );

  @override
  bool get hasImage {
    _$hasImageAtom.reportRead();
    return super.hasImage;
  }

  @override
  set hasImage(bool value) {
    _$hasImageAtom.reportWrite(value, super.hasImage, () {
      super.hasImage = value;
    });
  }

  late final _$hasVideoAtom = Atom(
    name: '_CreatePostStore.hasVideo',
    context: context,
  );

  @override
  bool get hasVideo {
    _$hasVideoAtom.reportRead();
    return super.hasVideo;
  }

  @override
  set hasVideo(bool value) {
    _$hasVideoAtom.reportWrite(value, super.hasVideo, () {
      super.hasVideo = value;
    });
  }

  late final _$listNameItemOptionAtom = Atom(
    name: '_CreatePostStore.listNameItemOption',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get listNameItemOption {
    _$listNameItemOptionAtom.reportRead();
    return super.listNameItemOption;
  }

  @override
  set listNameItemOption(ObservableList<Map<String, dynamic>> value) {
    _$listNameItemOptionAtom.reportWrite(value, super.listNameItemOption, () {
      super.listNameItemOption = value;
    });
  }

  late final _$listNameItemDraggableAtom = Atom(
    name: '_CreatePostStore.listNameItemDraggable',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get listNameItemDraggable {
    _$listNameItemDraggableAtom.reportRead();
    return super.listNameItemDraggable;
  }

  @override
  set listNameItemDraggable(ObservableList<Map<String, dynamic>> value) {
    _$listNameItemDraggableAtom.reportWrite(
      value,
      super.listNameItemDraggable,
      () {
        super.listNameItemDraggable = value;
      },
    );
  }

  late final _$pickImageFromGalleryAsyncAction = AsyncAction(
    '_CreatePostStore.pickImageFromGallery',
    context: context,
  );

  @override
  Future<void> pickImageFromGallery(BuildContext context) {
    return _$pickImageFromGalleryAsyncAction.run(
      () => super.pickImageFromGallery(context),
    );
  }

  late final _$getImageSizeAsyncAction = AsyncAction(
    '_CreatePostStore.getImageSize',
    context: context,
  );

  @override
  Future<Size> getImageSize(File file) {
    return _$getImageSizeAsyncAction.run(() => super.getImageSize(file));
  }

  late final _$pickVideoFromGalleryAsyncAction = AsyncAction(
    '_CreatePostStore.pickVideoFromGallery',
    context: context,
  );

  @override
  Future<void> pickVideoFromGallery() {
    return _$pickVideoFromGalleryAsyncAction.run(
      () => super.pickVideoFromGallery(),
    );
  }

  late final _$_CreatePostStoreActionController = ActionController(
    name: '_CreatePostStore',
    context: context,
  );

  @override
  void showDialogSelectImageOrVideo(BuildContext context) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
      name: '_CreatePostStore.showDialogSelectImageOrVideo',
    );
    try {
      return super.showDialogSelectImageOrVideo(context);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onTapOptionDraggable(BuildContext context, int index) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
      name: '_CreatePostStore.onTapOptionDraggable',
    );
    try {
      return super.onTapOptionDraggable(context, index);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onTapOptionPost(BuildContext context, int index) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
      name: '_CreatePostStore.onTapOptionPost',
    );
    try {
      return super.onTapOptionPost(context, index);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listFile: ${listFile},
isVideo: ${isVideo},
videoController: ${videoController},
fellingText: ${fellingText},
hasText: ${hasText},
initialChildSize: ${initialChildSize},
hasImage: ${hasImage},
hasVideo: ${hasVideo},
listNameItemOption: ${listNameItemOption},
listNameItemDraggable: ${listNameItemDraggable}
    ''';
  }
}
