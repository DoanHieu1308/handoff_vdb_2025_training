import 'package:flutter/material.dart';

import '../../core/base_widget/video/set_up_video_player.dart';
import '../../core/helper/size_util.dart';

class ShowVideoWithUrl extends StatelessWidget {
  final String videoUrl;
  const ShowVideoWithUrl({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtil.getMaxWidth(),
      child: SetUpVideoPlayer(
        key: UniqueKey(),
        fileVideo: null,
        videoUrl: videoUrl,
        autoPlay: true,
        startPaused: false,
        looping: false,
        fit: BoxFit.cover,
      ),
    );
  }
}
