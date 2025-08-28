import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:mobx/mobx.dart';

class ShowImage extends StatelessWidget {
  final dynamic fileImage;
  final bool isNetwork;

  const ShowImage({
    super.key,
    required this.fileImage,
    required this.isNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return isNetwork
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
        );
  }
}
