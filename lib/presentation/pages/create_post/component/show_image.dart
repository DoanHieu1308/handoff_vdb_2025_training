import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:mobx/mobx.dart';

class ShowImage extends StatelessWidget {
  final dynamic fileImage;
  final bool isNetwork;
  const ShowImage({super.key, required this.fileImage, required this.isNetwork});

  /// Get size of image
  @action
  Future<Size> getImageSize() async {
    Uint8List bytes;
    if (isNetwork) {
      final uri = Uri.parse(fileImage as String);
      final data = await NetworkAssetBundle(uri).load("");
      bytes = data.buffer.asUint8List();
    } else {
      bytes = await (fileImage as File).readAsBytes();
    }
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: getImageSize(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final imageSize = snapshot.data!;
          final aspectRatio = imageSize.width / imageSize.height;
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: isNetwork
                ? SetUpAssetImage(
                   key: UniqueKey(),
                   fileImage as String,
                   fit: BoxFit.cover,
                   filterQuality: FilterQuality.high,
                   gaplessPlayback: true,
                   errorBuilder: (context, error, stackTrace) {
                     return Text('Image load error');
                   },
                )
                : SetUpAssetImage(
                    key: UniqueKey(),
                    (fileImage as File).path,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                        return Text('Image load error');
                    },
                ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
