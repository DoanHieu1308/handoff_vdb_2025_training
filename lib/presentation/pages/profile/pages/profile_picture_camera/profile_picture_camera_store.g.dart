// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_picture_camera_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfilePictureCameraStore on _ProfilePictureCameraStore, Store {
  late final _$cameraControllerAtom = Atom(
    name: '_ProfilePictureCameraStore.cameraController',
    context: context,
  );

  @override
  CameraController? get cameraController {
    _$cameraControllerAtom.reportRead();
    return super.cameraController;
  }

  @override
  set cameraController(CameraController? value) {
    _$cameraControllerAtom.reportWrite(value, super.cameraController, () {
      super.cameraController = value;
    });
  }

  late final _$_camerasDescriptionAtom = Atom(
    name: '_ProfilePictureCameraStore._camerasDescription',
    context: context,
  );

  @override
  List<CameraDescription> get _camerasDescription {
    _$_camerasDescriptionAtom.reportRead();
    return super._camerasDescription;
  }

  @override
  set _camerasDescription(List<CameraDescription> value) {
    _$_camerasDescriptionAtom.reportWrite(value, super._camerasDescription, () {
      super._camerasDescription = value;
    });
  }

  late final _$selectedCameraDescriptionAtom = Atom(
    name: '_ProfilePictureCameraStore.selectedCameraDescription',
    context: context,
  );

  @override
  CameraDescription? get selectedCameraDescription {
    _$selectedCameraDescriptionAtom.reportRead();
    return super.selectedCameraDescription;
  }

  @override
  set selectedCameraDescription(CameraDescription? value) {
    _$selectedCameraDescriptionAtom.reportWrite(
      value,
      super.selectedCameraDescription,
      () {
        super.selectedCameraDescription = value;
      },
    );
  }

  late final _$isCameraInitializedAtom = Atom(
    name: '_ProfilePictureCameraStore.isCameraInitialized',
    context: context,
  );

  @override
  bool get isCameraInitialized {
    _$isCameraInitializedAtom.reportRead();
    return super.isCameraInitialized;
  }

  @override
  set isCameraInitialized(bool value) {
    _$isCameraInitializedAtom.reportWrite(value, super.isCameraInitialized, () {
      super.isCameraInitialized = value;
    });
  }

  late final _$flashModeAtom = Atom(
    name: '_ProfilePictureCameraStore.flashMode',
    context: context,
  );

  @override
  FlashMode get flashMode {
    _$flashModeAtom.reportRead();
    return super.flashMode;
  }

  @override
  set flashMode(FlashMode value) {
    _$flashModeAtom.reportWrite(value, super.flashMode, () {
      super.flashMode = value;
    });
  }

  late final _$imageFileAtom = Atom(
    name: '_ProfilePictureCameraStore.imageFile',
    context: context,
  );

  @override
  XFile? get imageFile {
    _$imageFileAtom.reportRead();
    return super.imageFile;
  }

  @override
  set imageFile(XFile? value) {
    _$imageFileAtom.reportWrite(value, super.imageFile, () {
      super.imageFile = value;
    });
  }

  late final _$isToggleCameraAtom = Atom(
    name: '_ProfilePictureCameraStore.isToggleCamera',
    context: context,
  );

  @override
  bool get isToggleCamera {
    _$isToggleCameraAtom.reportRead();
    return super.isToggleCamera;
  }

  @override
  set isToggleCamera(bool value) {
    _$isToggleCameraAtom.reportWrite(value, super.isToggleCamera, () {
      super.isToggleCamera = value;
    });
  }

  late final _$_isAllowInitCameraResumedAtom = Atom(
    name: '_ProfilePictureCameraStore._isAllowInitCameraResumed',
    context: context,
  );

  @override
  bool get _isAllowInitCameraResumed {
    _$_isAllowInitCameraResumedAtom.reportRead();
    return super._isAllowInitCameraResumed;
  }

  @override
  set _isAllowInitCameraResumed(bool value) {
    _$_isAllowInitCameraResumedAtom.reportWrite(
      value,
      super._isAllowInitCameraResumed,
      () {
        super._isAllowInitCameraResumed = value;
      },
    );
  }

  late final _$imageGalleryAtom = Atom(
    name: '_ProfilePictureCameraStore.imageGallery',
    context: context,
  );

  @override
  String get imageGallery {
    _$imageGalleryAtom.reportRead();
    return super.imageGallery;
  }

  @override
  set imageGallery(String value) {
    _$imageGalleryAtom.reportWrite(value, super.imageGallery, () {
      super.imageGallery = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ProfilePictureCameraStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$getCameraDescriptionAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore.getCameraDescription',
    context: context,
  );

  @override
  Future<void> getCameraDescription() {
    return _$getCameraDescriptionAsyncAction.run(
      () => super.getCameraDescription(),
    );
  }

  late final _$onNewCameraSelectedAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore.onNewCameraSelected',
    context: context,
  );

  @override
  Future<void> onNewCameraSelected({
    required CameraDescription cameraDescription,
  }) {
    return _$onNewCameraSelectedAsyncAction.run(
      () => super.onNewCameraSelected(cameraDescription: cameraDescription),
    );
  }

  late final _$_initializeCameraControllerAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore._initializeCameraController',
    context: context,
  );

  @override
  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) {
    return _$_initializeCameraControllerAsyncAction.run(
      () => super._initializeCameraController(cameraDescription),
    );
  }

  late final _$_setCameraDescriptionAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore._setCameraDescription',
    context: context,
  );

  @override
  Future<void> _setCameraDescription({
    required CameraDescription cameraDescription,
  }) {
    return _$_setCameraDescriptionAsyncAction.run(
      () => super._setCameraDescription(cameraDescription: cameraDescription),
    );
  }

  late final _$disposeCameraAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore.disposeCamera',
    context: context,
  );

  @override
  Future<void> disposeCamera() {
    return _$disposeCameraAsyncAction.run(() => super.disposeCamera());
  }

  late final _$capturePhotoAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore.capturePhoto',
    context: context,
  );

  @override
  Future<void> capturePhoto() {
    return _$capturePhotoAsyncAction.run(() => super.capturePhoto());
  }

  late final _$upLoadImageAsyncAction = AsyncAction(
    '_ProfilePictureCameraStore.upLoadImage',
    context: context,
  );

  @override
  Future<void> upLoadImage(BuildContext context, String imageGallery) {
    return _$upLoadImageAsyncAction.run(
      () => super.upLoadImage(context, imageGallery),
    );
  }

  late final _$_ProfilePictureCameraStoreActionController = ActionController(
    name: '_ProfilePictureCameraStore',
    context: context,
  );

  @override
  void disposeCameraController() {
    final _$actionInfo = _$_ProfilePictureCameraStoreActionController
        .startAction(
          name: '_ProfilePictureCameraStore.disposeCameraController',
        );
    try {
      return super.disposeCameraController();
    } finally {
      _$_ProfilePictureCameraStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final _$actionInfo = _$_ProfilePictureCameraStoreActionController
        .startAction(
          name: '_ProfilePictureCameraStore.didChangeAppLifecycleState',
        );
    try {
      return super.didChangeAppLifecycleState(state);
    } finally {
      _$_ProfilePictureCameraStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  CameraDescription _getTypeOfCameraDescription({
    required List<CameraDescription> cameraDescriptionList,
    required bool isBackCamera,
  }) {
    final _$actionInfo = _$_ProfilePictureCameraStoreActionController
        .startAction(
          name: '_ProfilePictureCameraStore._getTypeOfCameraDescription',
        );
    try {
      return super._getTypeOfCameraDescription(
        cameraDescriptionList: cameraDescriptionList,
        isBackCamera: isBackCamera,
      );
    } finally {
      _$_ProfilePictureCameraStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cameraController: ${cameraController},
selectedCameraDescription: ${selectedCameraDescription},
isCameraInitialized: ${isCameraInitialized},
flashMode: ${flashMode},
imageFile: ${imageFile},
isToggleCamera: ${isToggleCamera},
imageGallery: ${imageGallery},
isLoading: ${isLoading}
    ''';
  }
}
