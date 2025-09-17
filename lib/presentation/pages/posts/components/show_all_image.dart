import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/services/deep_link_service.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/post_link_content.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/post_reaction_overview.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/post_text_content.dart';
import 'package:handoff_vdb_2025/presentation/widget/show_image_with_url.dart';
import 'package:handoff_vdb_2025/presentation/widget/show_video_with_url.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/model/post/post_output_model.dart';
import '../../../widget/build_snackbar.dart';
import '../post_item_store.dart';
import 'full_screen_dialog_wrapper.dart';
import 'full_screen_image_viewer.dart';
import 'post_item_header.dart';

class ShowAllImage extends StatefulWidget {
  final String postId;

  ShowAllImage({super.key, required this.postId});

  @override
  State<ShowAllImage> createState() => _ShowAllImageState();
}

class _ShowAllImageState extends State<ShowAllImage> {
  final PostItemStore store = AppInit.instance.postItemStore;
  PostOutputModel? postData;
  bool showBanner = true;

  @override
  void initState() {
    super.initState();
    store.getPostById(
      postId: widget.postId,
      onSuccess: (post) {
        setState(() {
          postData = post;
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBarNotify(
            textNotify: error.toString(),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (postData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<String> mediaFiles = [
      ...?postData?.images,
      ...?postData?.videos,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb && showBanner) _buildNavigateApp(),
              PostItemHeader(postData: postData!, onTapMore: () {}),
              SizedBox(height: 5.h),
              PostReactionOverview(itemPost: postData!),
              SizedBox(height: 20.h),
              PostTextContent(
                text: postData?.title ?? '',
                onTapHashtag: (tag) {
                  print("Hashtag tapped: $tag");
                },
              ),
              if (mediaFiles.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  controller: store.scrollImageController,
                  itemCount: mediaFiles.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final mediaFile = mediaFiles[index];
                    final isVideo = mediaFile.isVideoFile;

                    return GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierColor: Colors.black.withValues(alpha: 0.95),
                          barrierDismissible: true,
                          barrierLabel:
                              MaterialLocalizations.of(
                                context,
                              ).modalBarrierDismissLabel,
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                          ) {
                            return FullscreenDialogWrapper(
                              child: FullScreenImageViewer(
                                mediaFile: mediaFile,
                                tag: 'img_$index',
                              ),
                            );
                          },
                          transitionBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            final fade = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            );
                            return FadeTransition(opacity: fade, child: child);
                          },
                        );
                      },
                      child: Hero(
                        tag: 'img_$index',
                        flightShuttleBuilder: (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return Material(
                                color: Colors.transparent,
                                child: Container(
                                  key: ValueKey(mediaFile),
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child:
                                      isVideo
                                          ? ShowVideoWithUrl(
                                            videoUrl: mediaFile,
                                          )
                                          : ShowImageWithUrl(
                                            imageUrl: mediaFile,
                                          ),
                                ),
                              );
                            },
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            key: ValueKey(mediaFile),
                            padding: EdgeInsets.only(bottom: 16.h),
                            child:
                                isVideo
                                    ? Stack(
                                      children: [
                                        ShowVideoWithUrl(videoUrl: mediaFile),
                                        Container(
                                          height: 200.h,
                                          width: SizeUtil.getMaxWidth(),
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    )
                                    : ShowImageWithUrl(imageUrl: mediaFile),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (mediaFiles.isEmpty &&
                  postData?.postLinkMeta?.postLinkUrl != null)
                PostLinkContent(postData: postData!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigateApp() {
    return SizedBox(
      height: 80,
      child: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('For a better experience, open our mobile app!'),
                AppSiteBox.h5,
                ElevatedButton(
                    onPressed: () async {
                      final androidStoreUrl = Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.yourcompany.handoff_vdb_2025',
                      );
                      final iosStoreUrl = Uri.parse(
                        'https://apps.apple.com/app/handoff-vdb-2025/id123456789',
                      );

                      // Sử dụng DeepLinkService để tạo deep links
                      final deepLinkUrl = Uri.parse("handoff://dashboard/posts/${widget.postId}");

                      try {
                        // Ưu tiên mở app
                        final launched = await launchUrl(
                          deepLinkUrl,
                          mode: LaunchMode.externalApplication,
                        );

                        // Nếu không mở được app → fallback sang store
                        if (!launched) {
                          final storeUrl = defaultTargetPlatform == TargetPlatform.iOS
                              ? iosStoreUrl
                              : androidStoreUrl;

                          await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
                        }
                      } catch (_) {
                        final storeUrl = defaultTargetPlatform == TargetPlatform.iOS
                            ? iosStoreUrl
                            : androidStoreUrl;

                        await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Text('Open App'),
                )
              ],
            ),
            Transform.translate(
              offset: Offset(350, 0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showBanner = false;
                  });
                },
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
