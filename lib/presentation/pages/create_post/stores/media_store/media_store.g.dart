// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MediaStore on _MediaStore, Store {
  late final _$listFileAtom = Atom(
    name: '_MediaStore.listFile',
    context: context,
  );

  @override
  ObservableList<dynamic> get listFile {
    _$listFileAtom.reportRead();
    return super.listFile;
  }

  @override
  set listFile(ObservableList<dynamic> value) {
    _$listFileAtom.reportWrite(value, super.listFile, () {
      super.listFile = value;
    });
  }

  late final _$imageListUrlAtom = Atom(
    name: '_MediaStore.imageListUrl',
    context: context,
  );

  @override
  ObservableList<String> get imageListUrl {
    _$imageListUrlAtom.reportRead();
    return super.imageListUrl;
  }

  @override
  set imageListUrl(ObservableList<String> value) {
    _$imageListUrlAtom.reportWrite(value, super.imageListUrl, () {
      super.imageListUrl = value;
    });
  }

  late final _$videoListUrlAtom = Atom(
    name: '_MediaStore.videoListUrl',
    context: context,
  );

  @override
  ObservableList<String> get videoListUrl {
    _$videoListUrlAtom.reportRead();
    return super.videoListUrl;
  }

  @override
  set videoListUrl(ObservableList<String> value) {
    _$videoListUrlAtom.reportWrite(value, super.videoListUrl, () {
      super.videoListUrl = value;
    });
  }

  late final _$videoControllerAtom = Atom(
    name: '_MediaStore.videoController',
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

  late final _$hasImageAtom = Atom(
    name: '_MediaStore.hasImage',
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
    name: '_MediaStore.hasVideo',
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

  late final _$pickImageFromGalleryAsyncAction = AsyncAction(
    '_MediaStore.pickImageFromGallery',
    context: context,
  );

  @override
  Future<void> pickImageFromGallery(BuildContext context) {
    return _$pickImageFromGalleryAsyncAction.run(
      () => super.pickImageFromGallery(context),
    );
  }

  late final _$pickVideoFromGalleryAsyncAction = AsyncAction(
    '_MediaStore.pickVideoFromGallery',
    context: context,
  );

  @override
  Future<void> pickVideoFromGallery() {
    return _$pickVideoFromGalleryAsyncAction.run(
      () => super.pickVideoFromGallery(),
    );
  }

  late final _$uploadAllFilesAndSplitAsyncAction = AsyncAction(
    '_MediaStore.uploadAllFilesAndSplit',
    context: context,
  );

  @override
  Future<void> uploadAllFilesAndSplit() {
    return _$uploadAllFilesAndSplitAsyncAction.run(
      () => super.uploadAllFilesAndSplit(),
    );
  }

  late final _$_MediaStoreActionController = ActionController(
    name: '_MediaStore',
    context: context,
  );

  @override
  void showDialogSelectImageOrVideo(BuildContext context) {
    final _$actionInfo = _$_MediaStoreActionController.startAction(
      name: '_MediaStore.showDialogSelectImageOrVideo',
    );
    try {
      return super.showDialogSelectImageOrVideo(context);
    } finally {
      _$_MediaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listFile: ${listFile},
imageListUrl: ${imageListUrl},
videoListUrl: ${videoListUrl},
videoController: ${videoController},
hasImage: ${hasImage},
hasVideo: ${hasVideo}
    ''';
  }
}
