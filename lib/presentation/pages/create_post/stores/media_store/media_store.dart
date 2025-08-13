import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/extensions/dynamic_extension.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../widget/custom_dialog.dart';
import '../../../profile/pages/profile_picture_camera/profile_picture_camera_store.dart';
import '../../create_post_store.dart';

part 'media_store.g.dart';

class MediaStore = _MediaStore with _$MediaStore;

abstract class _MediaStore with Store {
  /// Controller
  final ScrollController scrollController = ScrollController();

  /// Store
  final ProfilePictureCameraStore cameraStore = AppInit.instance.profilePictureCamera;

  /// Repository
  final PostRepository postRepository = AppInit.instance.postRepository;

  /// Image / Video
  final ImagePicker _picker = ImagePicker();
  @observable
  ObservableList<dynamic> listFile = ObservableList.of([]);
  @observable
  ObservableList<String> imageListUrl = ObservableList.of([]);
  @observable
  ObservableList<String> videoListUrl = ObservableList.of([]);
  @observable
  VideoPlayerController? videoController;

  @observable
  bool hasImage = false;
  @observable
  bool hasVideo = false;

  /// Store
  final CreatePostStore createPostStore;
  _MediaStore(this.createPostStore);

  /// Dispose
  void dispose() {
    try {
      videoController?.dispose();
    } catch (e) {
      print('Error disposing video controller: $e');
    }
  }

  /// Resize image
  Future<File> resizeImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    final resized = img.copyResize(image!, width: 1080);

    final tempDir = await getTemporaryDirectory();
    final resizedPath = '${tempDir.path}/resized_image.jpg';
    final resizedFile = File(resizedPath)
      ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));
    return resizedFile;
  }

  /// copy path image
  Future<File> copyToTempWithUniqueName(File file) async {
    final tempDir = await getTemporaryDirectory();
    final uniqueName =
        'media_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
    final newPath = path.join(tempDir.path, uniqueName);
    return await file.copy(newPath);
  }

  /// Get image from gallery
  @action
  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (picked == null) return;

      final pickedFile = File(picked.path);
      if (!await pickedFile.exists()) return;

      final croppedImage = await cameraStore.cropImage(pickedFile, context);
      if (croppedImage != null) {
        final cropImagePath = croppedImage.path;
        final croppedFile = File(cropImagePath);
        final imageResized = await resizeImage(croppedFile);
        if (imageResized.existsSync()) {
          final copiedFile = await copyToTempWithUniqueName(imageResized);

          //
          if (listFile.isEmpty) {
            listFile = ObservableList.of([copiedFile]);
          } else {
            listFile.add(copiedFile);
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          hasImage = true;
          hasVideo = false;

          // Tìm video đầu tiên trong listFile
          final videoFile = listFile.firstWhere(
                (f) => _isVideoFile(f),
            orElse: () => null,
          );

          if (videoFile == null) return;

          String path;
          if (videoFile is File) {
            path = videoFile.path;
            if (path.isNotEmpty && await videoFile.exists()) {
              await _initializeVideoController(videoFile);
            }
          } else if (videoFile is String) {
            path = videoFile;
            if (path.isNotEmpty) {
              // Nếu là URL thì xử lý khác, ví dụ:
              await _initializeVideoController(path);
            }
          }
        }
      }
    } catch (e) {
      _reset();
    }
  }

  /// Get video from gallery
  @action
  Future<void> pickVideoFromGallery() async {
    try {
      final picked = await _picker.pickVideo(source: ImageSource.gallery);
      if (picked == null) return;

      final pickedFile = File(picked.path);
      if (!await pickedFile.exists()) return;


      listFile.add(pickedFile);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });

      hasImage = false;
      hasVideo = true;

      await _initializeVideoController(pickedFile);
    } catch (e) {
      _reset();
    }
  }

  /// Initialize video controller
  Future<void> _initializeVideoController(dynamic file) async {
    try {
      videoController?.dispose();

      if (file is File) {
        videoController = VideoPlayerController.file(file);
      } else if (file is String) {
        if (file.startsWith('http')) {
          videoController = VideoPlayerController.networkUrl(Uri.parse(file));
        } else {
          videoController = VideoPlayerController.file(File(file));
        }
      } else {
        throw Exception("Unsupported file type: ${file.runtimeType}");
      }

      await videoController!.initialize();
      await videoController!.setLooping(true);
      await videoController!.play();
    } catch (e) {
      print('Error initializing video controller: $e');
      videoController?.dispose();
      videoController = null;
    }
  }


  /// check video
  bool _isVideoFile(dynamic file) {
    if(file is File){
      return file.isVideo;
    }else if(file is String){
      return file.isVideo;
    }
    return false;
  }

  /// Reset
  void _reset() {
    listFile.clear();
    hasImage = false;
    hasVideo = false;
    try {
      videoController?.dispose();
    } catch (e) {
      print('Error disposing video controller in reset: $e');
    }
    videoController = null;
  }

  /// Remove file
  void removeFile(dynamic target) {
    listFile.removeWhere((f) => f == target);

    // Nếu bạn muốn reset khi danh sách trống
    if (listFile.isEmpty) {
      _reset();
    }
  }

  @action
  Future<void> uploadAllFilesAndSplit() async {
    imageListUrl.clear();
    videoListUrl.clear();

    for (final file in listFile) {
      if(file is File){
        await postRepository.uploadFileMultipart(
          file: file,
          onSuccess: (finalUrl) {
            if (file.path.isVideoFile) {
              videoListUrl.add(finalUrl);
            } else {
              imageListUrl.add(finalUrl);
            }
          },
          onError: (error) {
            print("Error uploading ${file.path}: $error");
          },
        );
      } else{
        if((file as String).isVideoFile){
          videoListUrl.add(file);
        }else{
          imageListUrl.add(file);
        }
      }
    }
  }

  /// Show dialog select image or video
  @action
  void showDialogSelectImageOrVideo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Bạn muốn chọn ảnh hay video?",
          message: "------------------",
          textNumber1: "Ảnh",
          textNumber2: "Video",
          onTapNumber1: () {
            Navigator.pop(context);
            pickImageFromGallery(context);
          },
          onTapNumber2: () {
            pickVideoFromGallery();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// Check file limits before adding
  void checkFileLimit(BuildContext context){
    if(listFile.length < 7){
      showDialogSelectImageOrVideo(context);
    }
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text('Bạn chỉ được chọn tối đa 3 ảnh hoặc video.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

}