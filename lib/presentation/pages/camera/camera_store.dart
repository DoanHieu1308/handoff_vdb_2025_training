import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/profile_store.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

import '../../widget/build_snackbar.dart';

part 'camera_store.g.dart';

class CameraStore = _CameraStore with _$CameraStore;

abstract class _CameraStore with Store {
  /// Repository
  final UserRepository _userRepository = AppInit.instance.userRepository;

  /// Store
  ProfileStore profileStore = AppInit.instance.profileStore;

  /// Controller
  @observable
  CameraController? cameraController;
  @observable
  List<CameraDescription> _camerasDescription = <CameraDescription>[];
  @observable
  CameraDescription? selectedCameraDescription;

  /// Camera state
  @observable
  bool isCameraInitialized = false;
  @observable
  FlashMode flashMode = FlashMode.off;
  @observable
  XFile? imageFile;
  @observable
  bool isToggleCamera = false;
  @observable
  bool _isAllowInitCameraResumed = false;

  /// Image Gallery
  @observable
  String imageGallery = '';

  /// Loading state
  @observable
  bool isLoading = false;

  /// Timer call video
  Timer? _debounceSpamToggleCamera;

  /// Init
  Future<void> init() async {
    getCameraDescription();
  }

  ///
  /// Dispose camera
  ///
  @action
  void disposeCameraController() {
    if (cameraController != null) {
      cameraController!.dispose();
      cameraController = null;
      isCameraInitialized = false;
    }
  }

  /// Did change app
  @action
  void didChangeAppLifecycleState(AppLifecycleState state){
    final CameraController? newCameraController = cameraController;

    if (newCameraController == null || !newCameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused) {
      newCameraController.dispose();
      _isAllowInitCameraResumed = true;
      isCameraInitialized = false;
    }

    if (state == AppLifecycleState.resumed && _isAllowInitCameraResumed) {
      _initializeCameraController(newCameraController.description);
    }

  }

  /// Init camera
  @action
  Future<void> getCameraDescription() async {
    try {
      isLoading = true;
      _camerasDescription = await availableCameras();
      if (_camerasDescription.isEmpty) return;

      final cameraDesc = _getTypeOfCameraDescription(
        cameraDescriptionList: _camerasDescription,
        isBackCamera: !isToggleCamera,
      );

      await onNewCameraSelected(cameraDescription: cameraDesc);
    } on CameraException catch (e, s) {
      log('Error get camera description ${e.code}', stackTrace: s);
    } finally {
      isLoading = false;
    }
  }

  /// Select back or front camera
  @action
  CameraDescription _getTypeOfCameraDescription({
    required List<CameraDescription> cameraDescriptionList,
    required bool isBackCamera,
  }) {
    return cameraDescriptionList.firstWhere(
          (camera) => camera.lensDirection == (isBackCamera ? CameraLensDirection.back : CameraLensDirection.front),
      orElse: () => cameraDescriptionList.first,
    );
  }

  /// Switch camera
  @action
  Future<void> onNewCameraSelected({required CameraDescription cameraDescription}) async {
    await _setCameraDescription(cameraDescription: cameraDescription);
  }

  /// Initialize camera controller
  @action
  Future<void> _initializeCameraController(CameraDescription cameraDescription) async {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();
      selectedCameraDescription = cameraDescription;
      isCameraInitialized = true;
    } catch (e, s) {
      log("Error initializing camera: $e", stackTrace: s);
      isCameraInitialized = false;
    }
  }

  /// Set new camera
  @action
  Future<void> _setCameraDescription({required CameraDescription cameraDescription}) async {
    final oldController = cameraController;
    cameraController = null;

    if (oldController != null) {
      await oldController.dispose();
    }

    await _initializeCameraController(cameraDescription);
  }

  /// Dispose camera
  @action
  Future<void> disposeCamera() async {
    try {
      await cameraController?.dispose();
    } catch (_) {}
    cameraController = null;
    isCameraInitialized = false;
  }

  ///
  /// Capture photo
  ///
  @action
  Future<void> capturePhoto() async {
    if (cameraController != null && cameraController!.value.isInitialized && !cameraController!.value.isTakingPicture) {
      try {
        await cameraController!.setFlashMode(flashMode);
        imageFile = await cameraController!.takePicture();
        imageGallery = imageFile!.path.toString();
      } catch (e) {
        log('Error capturing photo: $e');
      }
    }
  }


  ///
  /// Get Image from gallery
  ///
  Future<void> getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedImage = await cropImage(File(pickedFile.path), context);

      if (croppedImage != null) {
        imageGallery = croppedImage.path;
        await upLoadImage(context, imageGallery);
      }
    }
  }


  ///
  /// Crop image
  ///
  Future<void> onTapCrop(BuildContext context) async {
    final croppedImage = await cropImage(File(imageGallery), context);
    if (croppedImage != null) {
      imageGallery = croppedImage.path;
      await upLoadImage(context, imageGallery);
    }
  }

  Future<CroppedFile?> cropImage(File imageFile, BuildContext context) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      return croppedFile;
    } else {
      return null;
    }
  }


  ///
  /// Api upload
  ///
  @action
  Future<void> upLoadImage(BuildContext context, String imageGallery) async {
     isLoading = true;
     await _userRepository.uploadAvata(
         image: imageGallery,
         onSuccess: (){
           if (context.mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               buildSnackBarNotify(textNotify: "Successfully Upload Avata"),
             );
           }
           profileStore.getUserProfile();
           Navigator.pop(context);
         },
         onError: (error){
           ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(error)));
         }
     );
     isLoading = false;
  }

  ///
  /// On change camera.
  ///
  Future<void> onChangeCamera() async {
    if (_debounceSpamToggleCamera?.isActive ?? false) _debounceSpamToggleCamera?.cancel();
    _debounceSpamToggleCamera = Timer(const Duration(milliseconds: 300), () async {
      isToggleCamera = !isToggleCamera;

      final cameraDesc = _getTypeOfCameraDescription(
        cameraDescriptionList: _camerasDescription,
        isBackCamera: !isToggleCamera,
      );
      onNewCameraSelected(cameraDescription: cameraDesc);
    });
  }
}
