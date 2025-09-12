import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/extensions/dynamic_extension.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/text_store/text_store.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:video_player/video_player.dart';

import '../../../../widget/select_dialog_widget.dart';
import '../../../profile/pages/profile_picture_camera/profile_picture_camera_store.dart';
import '../../create_post_store.dart';

part 'media_store.g.dart';

class MediaStore = _MediaStore with _$MediaStore;

abstract class _MediaStore with Store {
  /// Controller
  final ScrollController scrollController = ScrollController();

  /// Store
  final ProfilePictureCameraStore cameraStore = AppInit.instance.profilePictureCamera;
  TextStore get textStore => AppInit.instance.textStore;

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
  
  @observable
  bool isProcessingImage = false;

  /// Store
  final CreatePostStore createPostStore;
  _MediaStore(this.createPostStore);

  /// Dispose
  void dispose() {
    try {
      videoController?.dispose();
      scrollController.dispose();
    } catch (e) {
      print('Error disposing media store: $e');
    }
  }

  /// Resize image using background thread
  Future<File> resizeImageSync(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final resized = img.copyResize(image, width: 1080);
    final resizedFile = File(file.path)..writeAsBytesSync(img.encodeJpg(resized, quality: 85));
    return resizedFile;
  }

  /// Copy file to temp with unique name
  Future<File> copyToTempWithUniqueName(File file) async {
    final tempDir = await getTemporaryDirectory();
    final uniqueName = 'media_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
    final newPath = path.join(tempDir.path, uniqueName);
    return await file.copy(newPath);
  }

  /// Get image from gallery
  @action
  Future<void> pickImagesFromGallery(BuildContext context) async {
    try {
      isProcessingImage = true;

      final pickedList = await _picker.pickMultiImage();
      if (pickedList.isEmpty) {
        isProcessingImage = false;
        return;
      }

      for (final picked in pickedList) {
        final pickedFile = File(picked.path);
        if (!await pickedFile.exists()) continue;

        // final croppedImage = await cameraStore.cropImage(pickedFile, context);
        // if (croppedImage == null) continue;

        final croppedFile = File(pickedFile.path);

        final processedFile = await resizeImageSync(croppedFile);
        if (!await processedFile.exists()) continue;

        listFile.add(processedFile);
      }

      if (listFile.isNotEmpty) {
        hasImage = true;
        hasVideo = false;

        // Scroll xuống cuối sau khi thêm
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        // Check video
        await _checkAndInitializeVideoController();
      }
    } catch (e) {
      print('Error picking multiple images: $e');
      _reset();
    } finally {
      isProcessingImage = false;
    }
  }

  /// Crop Image
  @action
  Future<void> cropImageAtIndex(BuildContext context, int index) async {
    try {
      if (index < 0 || index >= listFile.length) return;

      final fileToCrop = listFile[index];
      if (!await fileToCrop.exists()) return;

      final croppedImage = await cameraStore.cropImage(fileToCrop, context);
      if (croppedImage == null) return;

      final croppedFile = File(croppedImage.path);
      final processedFile = await resizeImageSync(croppedFile);
      if (!await processedFile.exists()) return;

      listFile[index] = processedFile;

    } catch (e) {
      print('Error cropping image at index $index: $e');
    }
  }

  /// Get video from gallery
  @action
  Future<void> pickVideoFromGallery() async {
    try {
      final picked = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10), // Limit video duration
      );
      if (picked == null) return;

      final pickedFile = File(picked.path);
      if (!await pickedFile.exists()) return;

      // Check file size (limit to 100MB)
      final fileSize = await pickedFile.length();
      if (fileSize > 100 * 1024 * 1024) {
        throw Exception('Video file too large. Maximum size is 100MB.');
      }

      listFile.add(pickedFile);

      // Scroll to bottom smoothly
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
      print('Error picking video: $e');
      _reset();
    }
  }

  /// Check for video files and initialize controller
  Future<void> _checkAndInitializeVideoController() async {
    try {
      final videoFile = listFile.firstWhere(
        (f) => _isVideoFile(f),
        orElse: () => null,
      );

      if (videoFile != null) {
        String path;
        if (videoFile is File) {
          path = videoFile.path;
          if (path.isNotEmpty && await videoFile.exists()) {
            await _initializeVideoController(videoFile);
          }
        } else if (videoFile is String) {
          path = videoFile;
          if (path.isNotEmpty) {
            await _initializeVideoController(path);
          }
        }
      }
    } catch (e) {
      print('Error checking video files: $e');
    }
  }

  /// Initialize video controller
  Future<void> _initializeVideoController(dynamic file) async {
    try {
      // Dispose previous controller
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
    
    } catch (e) {
      print('Error initializing video controller: $e');
      videoController?.dispose();
      videoController = null;
    }
  }

  /// Check video file
  bool _isVideoFile(dynamic file) {
    if (file is File) {
      return file.isVideo;
    } else if (file is String) {
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

    // Reset if list is empty
    if (listFile.isEmpty) {
      _reset();
    }
  }

  @action
  Future<void> uploadAllFilesAndSplit() async {
    imageListUrl.clear();
    videoListUrl.clear();

    for (final file in listFile) {
      if (file is File) {
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
      } else {
        if ((file as String).isVideoFile) {
          videoListUrl.add(file);
        } else {
          imageListUrl.add(file);
        }
      }
    }
  }

  /// Show dialog select image or video
  void showDialogSelectImageOrVideo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SelectDialogWidget(
          titleText: "Chọn phương thức",
          option1Text: "Chọn ảnh",
          option2Text: "Chọn video",
          onOption1Tap: () => pickImagesFromGallery(context),
          onOption2Tap: () => pickVideoFromGallery(),
          showIcon: true,
        );
      },
    );
  }

  /// Check file limits before adding
  void checkFileLimit(BuildContext context) {
    if (listFile.length < 7) {
      showDialogSelectImageOrVideo(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Bạn chỉ được chọn tối đa 7 ảnh hoặc video.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  /// Check type share value
  void handleSharedFiles(List files) {
    try {
      for (final file in files) {
        if (file is SharedMediaFile) {
          final filePath = file.path;
          final fileType = file.type;

          if (fileType == SharedMediaType.image) {
            // Add image to media store
            listFile.add(File(filePath) as dynamic);
            hasImage = true;
            imageListUrl.add(filePath);
          } else if (fileType == SharedMediaType.video) {
            // Add video to media store
            listFile.add(File(filePath) as dynamic);
            hasVideo = true;
            videoListUrl.add(filePath);
          } else if (fileType == SharedMediaType.url) {
            textStore.feelingEditingController.text = filePath;
          }
        }
      }
    } catch (e) {
      print('Error handling shared files: $e');
    }
  }
}