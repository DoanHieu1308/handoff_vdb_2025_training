import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/camera/camera_store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../core/utils/images_path.dart';
import '../../widget/custom_dialog.dart';

part 'create_post_store.g.dart';

class CreatePostStore = _CreatePostStore with _$CreatePostStore;

abstract class _CreatePostStore with Store {
  /// Store
  final CameraStore cameraStore = AppInit.instance.cameraStore;

  /// Controller
  final feelingEditingController = TextEditingController();
  final DraggableScrollableController controllerDraggableScrollable =
      DraggableScrollableController();
  final ScrollController scrollController = ScrollController();

  /// Focus node
  final FocusNode feelingFocusNode = FocusNode();

  /// Image / Video
  final ImagePicker _picker = ImagePicker();
  @observable
  ObservableList<File> listFile = ObservableList.of([]);
  @observable
  bool isVideo = false;
  @observable
  VideoPlayerController? videoController;

  ///
  @observable
  String fellingText = '';
  @observable
  bool hasText = false;
  @observable
  double initialChildSize = 0.5;

  /// Image/Video
  @observable
  bool hasImage = false;
  @observable
  bool hasVideo = false;

  /// Init
  Future<void> init() async {
    feelingEditingController.addListener(() {
      fellingText = feelingEditingController.text;
      hasText = fellingText.isNotEmpty;
    });

    feelingFocusNode.addListener(() {
      if (feelingFocusNode.hasFocus) {
        initialChildSize = 0.2;
      } else {
        initialChildSize = 0.5;
      }
    });
  }

  /// Dispose
  void dispose() {
    videoController?.dispose();
  }

  /// List item detail all
  @observable
  ObservableList<Map<String, dynamic>> listNameItemOption = ObservableList.of([
    {'name': "Chỉ mình tôi", 'image': ImagesPath.icLock, 'valueNumber': 0},
    {'name': "Album", 'image': ImagesPath.icAdd, 'valueNumber': 1},
    {'name': "Đang tắt", 'image': ImagesPath.icInstagram, 'valueNumber': 2},
    {'name': "Đang tắt ", 'image': ImagesPath.icThreads, 'valueNumber': 3},
    {'name': "Nhãn AL đang tắt", 'image': ImagesPath.icAdd, 'valueNumber': 4},
  ]);

  /// List item detail all
  @observable
  ObservableList<Map<String, dynamic>> listNameItemDraggable =
      ObservableList.of([
        {'name': "Ảnh/Video", 'image': ImagesPath.icPhotos, 'valueNumber': 1},
        {
          'name': "Gắn thẻ người khác",
          'image': ImagesPath.icTag,
          'valueNumber': 2,
        },
        {
          'name': "Cảm xúc/hoạt động",
          'image': ImagesPath.icFeeling,
          'valueNumber': 3,
        },
        {'name': "Check in ", 'image': ImagesPath.icCheckIn, 'valueNumber': 4},
        {
          'name': "Video trực tiếp",
          'image': ImagesPath.icVideoCamera,
          'valueNumber': 5,
        },
        {
          'name': "Màu nền",
          'image': ImagesPath.icBackGroundColor,
          'valueNumber': 6,
        },
        {'name': "Camera", 'image': ImagesPath.icCameraColor, 'valueNumber': 7},
        {'name': "Nhạc", 'image': ImagesPath.icMusic, 'valueNumber': 8},
      ]);

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

          isVideo = false;
          hasImage = true;
          hasVideo = false;

          // Tìm video đầu tiên trong listFile
          final videoFile = listFile.firstWhere(
            (f) => _isVideoFile(f.path),
            orElse: () => File(''),
          );

          // Nếu tồn tại video trong list thì khởi tạo lại controller
          if (videoFile.path.isNotEmpty && await videoFile.exists()) {
            await _initializeVideoController(videoFile);
          }
        }
      }
    } catch (e) {
      _reset();
    }
  }

  /// Get size of image
  @action
  Future<Size> getImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
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

      isVideo = true;
      hasImage = false;
      hasVideo = true;

      await _initializeVideoController(pickedFile);
    } catch (e) {
      _reset();
    }
  }

  /// Initialize video controller
  Future<void> _initializeVideoController(File file) async {
    videoController?.dispose();
    videoController = VideoPlayerController.file(file);
    await videoController!.initialize();
    await videoController!.setLooping(true);
    await videoController!.play();
  }

  /// check video
  bool _isVideoFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') || ext.endsWith('.mov') || ext.endsWith('.avi');
  }

  /// Reset
  void _reset() {
    listFile.clear();
    isVideo = false;
    hasImage = false;
    hasVideo = false;
    videoController?.dispose();
    videoController = null;
  }

  /// Remove file
  void removeFile(File target) {
    listFile.removeWhere((f) => f.path == target.path);

    // Nếu bạn muốn reset khi danh sách trống
    if (listFile.isEmpty) {
      _reset();
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
    if(listFile.length < 3){
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

  /// OnTap option draggable
  @action
  void onTapOptionDraggable(BuildContext context, int index) {
    final value = listNameItemDraggable[index]['valueNumber'];
    print(value);

    switch (value) {
      case 1:
        showDialogSelectImageOrVideo(context);
        break;
      case 2:
        Navigator.of(context).pushNamed(AuthRouters.TAG_FRIEND);
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      default:
        break;
    }
  }

  /// OnTap option draggable
  @action
  void onTapOptionPost(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(AuthRouters.STATUS_POST);
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        break;
    }
  }
}
