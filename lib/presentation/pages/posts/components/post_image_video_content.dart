import 'dart:ui';
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
  PostItemStore store = AppInit.instance.postItemStore;
  final PostOutputModel postData;

  PostImageVideoContent({super.key, required this.postData});

  bool isVideo(String fileUrl) => fileUrl.isVideoFile;

  @override
  Widget build(BuildContext context) {
    try {
      final List<String> mediaFiles = [
        ...?postData.images,
        ...?postData.videos,
      ];

      final count = mediaFiles.length;

      if (count == 0) return const SizedBox.shrink();
      if (count == 1) {
        return buildSingleMedia(mediaFiles[0]);
      }
      if (count == 2) {
        return buildTwoMedia(mediaFiles);
      }
      if (count == 3) {
        return buildThreeMedia(mediaFiles);
      }
      if (count == 4) {
        return buildFourMedia(mediaFiles);
      }
      // 5+ media files
      return buildMultipleMedia(mediaFiles);
    } catch (e) {
      // Fallback widget if there's an error
      return Container(
        width: SizeUtil.getMaxWidth(),
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(3),
        ),
        child: const Center(
          child: Icon(
            Icons.error,
            color: Colors.grey,
            size: 32,
          ),
        ),
      );
    }
  }

  /// Single media - preserve original dimensions
  Widget buildSingleMedia(String fileUrl) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: buildMedia(fileUrl),
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  /// Two media - equal size, side by side
  Widget buildTwoMedia(List<String> mediaFiles) {
    try {
      return SizedBox(
        width: SizeUtil.getMaxWidth(),
        height: 200.h, // Fixed height for consistency
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: buildMedia(mediaFiles[0]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: buildMedia(mediaFiles[1]),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  /// Three media - left 1 large, right 2 stacked (equal frame sizes)
  Widget buildThreeMedia(List<String> mediaFiles) {
    try {
      return SizedBox(
        width: SizeUtil.getMaxWidth(),
        height: 280.h, // Increased height for larger frames
        child: Row(
          children: [
            // Left - 1 large media (50% width)
            SizedBox(
              width: SizeUtil.getMaxWidth() * 0.5 - 1, // Exactly half width minus padding
              height: 280.h, // Full height
              child: Padding(
                padding: const EdgeInsets.only(right: 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: buildMedia(mediaFiles[0]),
                ),
              ),
            ),
            // Right - 2 media stacked (50% width) - equal sizes
            SizedBox(
              width: SizeUtil.getMaxWidth() * 0.5 - 1, // Exactly half width minus padding
              height: 280.h, // Full height
              child: Column(
                children: [
                  // Top media - 50% height
                  SizedBox(
                    width: SizeUtil.getMaxWidth() * 0.5 - 1, // Full right side width minus padding
                    height: 140.h, // Exactly half of 280.h
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, bottom: 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: buildMedia(mediaFiles[1]),
                      ),
                    ),
                  ),
                  // Bottom media - 50% height
                  SizedBox(
                    width: SizeUtil.getMaxWidth() * 0.5 - 1, // Full right side width minus padding
                    height: 140.h, // Exactly half of 280.h
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, top: 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: buildMedia(mediaFiles[2]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  /// Four media - left 1 large, right 3 in grid (equal frame sizes)
  Widget buildFourMedia(List<String> mediaFiles) {
    try {
      return SizedBox(
        width: SizeUtil.getMaxWidth(),
        height: 280.h, // Increased height for larger frames
        child: Row(
          children: [
            // Left - 1 large media (50% width)
            SizedBox(
              width: SizeUtil.getMaxWidth() * 0.5 - 1, // Exactly half width minus padding
              height: 280.h, // Full height
              child: Padding(
                padding: const EdgeInsets.only(right: 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: buildMedia(mediaFiles[0]),
                ),
              ),
            ),
            // Right - 3 media in grid (50% width) - equal sizes
            SizedBox(
              width: SizeUtil.getMaxWidth() * 0.5 - 1, // Exactly half width minus padding
              height: 280.h, // Full height
              child: Column(
                children: [
                  // Top row - 2 media (50% height each)
                  SizedBox(
                    height: 140.h, // Exactly half of 280.h
                    child: Row(
                      children: [
                        SizedBox(
                          width: (SizeUtil.getMaxWidth() * 0.5 - 2) / 2, // Exactly half of right side width minus padding
                          height: 140.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1, bottom: 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: buildMedia(mediaFiles[1]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (SizeUtil.getMaxWidth() * 0.5 - 2) / 2, // Exactly half of right side width minus padding
                          height: 140.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1, bottom: 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: buildMedia(mediaFiles[2]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom row - 1 media (50% height)
                  SizedBox(
                    width: SizeUtil.getMaxWidth() * 0.5 - 2, // Full right side width minus padding
                    height: 140.h, // Exactly half of 280.h
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, top: 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: buildMedia(mediaFiles[3]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  /// 5+ media - left 1 large, right 3 with overlay (equal frame sizes)
  Widget buildMultipleMedia(List<String> mediaFiles) {
    try {
      return SizedBox(
        width: SizeUtil.getMaxWidth(),
        height: 280.h, // Increased height for larger frames
        child: Row(
          children: [
            // Left - 1 large media (50% width)
            SizedBox(
              width: SizeUtil.getMaxWidth() * 0.5 - 1, // Exactly half width minus padding
              height: 280.h, // Full height
              child: Padding(
                padding: const EdgeInsets.only(right: 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: buildMedia(mediaFiles[0]),
                ),
              ),
            ),
            // Right - 3 media with overlay (50% width) - equal sizes
            SizedBox(
              width: SizeUtil.getMaxWidth() * 0.5 - 1, // Exactly half width minus padding
              height: 280.h, // Full height
              child: Column(
                children: [
                  // Top row - 2 media (50% height each)
                  SizedBox(
                    height: 140.h, // Exactly half of 280.h
                    child: Row(
                      children: [
                        SizedBox(
                          width: (SizeUtil.getMaxWidth() * 0.5 - 2) / 2, // Exactly half of right side width minus padding
                          height: 140.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1, bottom: 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: buildMedia(mediaFiles[1]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (SizeUtil.getMaxWidth() * 0.5 - 2) / 2, // Exactly half of right side width minus padding
                          height: 140.h,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1, bottom: 1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: buildMedia(mediaFiles[2]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom row - 1 media with overlay (50% height)
                  SizedBox(
                    width: SizeUtil.getMaxWidth() * 0.5 - 2, // Full right side width minus padding
                    height: 140.h, // Exactly half of 280.h
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, top: 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            buildMedia(mediaFiles[3]),
                            // Overlay showing remaining count
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  '+${mediaFiles.length - 4}',
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
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget buildMedia(String fileUrl) {
    return isVideo(fileUrl) ? buildShowVideo(fileUrl) : buildShowImage(fileUrl);
  }

  /// Show video
  Widget buildShowVideo(String videoUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SetUpVideoPlayer(
        key: UniqueKey(),
        videoUrl: videoUrl,
        autoPlay: true,
        startPaused: false,
        looping: false,
        fit: BoxFit.cover,
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
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  /// Error widget fallback
  Widget _buildErrorWidget() {
    return Container(
      width: SizeUtil.getMaxWidth(),
      height: 280.h, // Updated to match new layout heights
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Center(
        child: Icon(
          Icons.error,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
