import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import '../../../../core/base_widget/video/set_up_video_player.dart';
import '../post_item_store.dart';


class PostImageVideoContent extends StatelessWidget {
  PostItemStore store = AppInit.instance.postStatusStore;
  final PostOutputModel postData;

  PostImageVideoContent({super.key, required this.postData});

  bool isVideo(String fileUrl) => fileUrl.isVideoFile;


  @override
  Widget build(BuildContext context) {
    final List<String> mediaFiles = [
      ...?postData.images,
      ...?postData.videos,
    ];

    final count = mediaFiles.length;

    if (count == 1) {
      return buildMedia(mediaFiles[0]);
    }

    // Limit to show only first 4 files
    final displayCount = count > 4 ? 4 : count;
    final remainingCount = count > 4 ? count - 4 : 0;

    return SizedBox(
      width: SizeUtil.getMaxWidth(),
      height: 300.h,
      child: Row(
        children: [
          /// Left column: always shows first media, full height
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: buildMedia(mediaFiles[0]),
            ),
          ),

          /// Right column: 2+ items (max 3 items)
          Expanded(
            flex: 2,
            child: Column(
              children: List.generate(
                displayCount - 1,
                    (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Stack(
                      children: [
                        buildMedia(mediaFiles[index + 1]),
                        // Show overlay for 4th item when there are more than 4 files
                        if (index == 2 && remainingCount > 0)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Center(
                              child: Text(
                                '+$remainingCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMedia(String fileUrl) {
    return isVideo(fileUrl) ? buildShowVideo(fileUrl) : buildShowImage(fileUrl);
  }

  /// Show video
  Widget buildShowVideo(String videoUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: double.infinity,
        child: SetUpVideoPlayer(
          key: UniqueKey(),
          videoUrl: videoUrl,
          autoPlay: true,
          looping: true,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Show Image
  Widget buildShowImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SetUpAssetImage(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

}
