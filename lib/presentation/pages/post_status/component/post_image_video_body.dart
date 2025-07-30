import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';

import '../../../../core/base_widget/video/set_up_video_player.dart';


class PostImageVideoBody extends StatelessWidget {
  final List<File> mediaFiles;
  PostImageVideoBody({super.key, required this.mediaFiles});

  bool isVideo(File file) => file.path.isVideoFile;


  @override
  Widget build(BuildContext context) {
    final count = mediaFiles.length;

    if (count == 1) {
      return buildMedia(mediaFiles[0]);
    }

    return Row(
      children: [
        /// Left column: always shows first media, full height
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: buildMedia(mediaFiles[0]),
          ),
        ),

        /// Right column: 2+ items
        Expanded(
          flex: 2,
          child: Column(
            children: List.generate(
              count - 1,
                  (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: buildMedia(mediaFiles[index + 1]),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildMedia(File file) {
    return isVideo(file) ? buildShowVideo(file) : buildShowImage(file);
  }

  /// Reuse your widgets here:
  Widget buildShowVideo(File fileVideo) {
    return SizedBox(
      width: double.infinity,
      child: SetUpVideoPlayer(
        key: UniqueKey(),
        fileVideo: fileVideo,
        videoUrl: '',
        autoPlay: true,
        looping: true,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildShowImage(File fileImage) {
    return FutureBuilder<Size>(
      future: getImageSize(fileImage),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final imageSize = snapshot.data!;
          final aspectRatio = imageSize.width / imageSize.height;
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: Image.file(
              key: UniqueKey(),
              fileImage,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Image load error');
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Size> getImageSize(File imageFile) async {
    final completer = Completer<Size>();
    final image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }
}
