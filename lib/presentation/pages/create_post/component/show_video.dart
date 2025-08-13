import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/base_widget/video/set_up_video_player.dart';
import '../../../../core/helper/size_util.dart';

class ShowVideo extends StatelessWidget {
  final dynamic fileVideo;
  final bool isNetwork;

  const ShowVideo({
    super.key,
    required this.fileVideo,
    required this.isNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtil.getMaxWidth(),
      child: SetUpVideoPlayer(
        key: UniqueKey(),
        fileVideo: isNetwork ? null : fileVideo as File,
        videoUrl: isNetwork ? fileVideo as String : "",
        autoPlay: false,
        looping: false,
        fit: BoxFit.cover,
      ),
    );
  }
}
