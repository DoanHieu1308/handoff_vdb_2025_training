import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/post_link_content.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/post_reaction_overview.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/post_text_content.dart';
import 'package:handoff_vdb_2025/presentation/widget/show_image_with_url.dart';
import 'package:handoff_vdb_2025/presentation/widget/show_video_with_url.dart';
import '../../../../data/model/post/post_output_model.dart';
import '../post_item_store.dart';
import 'full_screen_dialog_wrapper.dart';
import 'full_screen_image_viewer.dart';
import 'post_item_header.dart';

class ShowAllImage extends StatelessWidget {
  final PostOutputModel postData;
  final String postId;
  final PostItemStore store = AppInit.instance.postItemStore;
  ShowAllImage({super.key, required this.postData, required this.postId});

  @override
  Widget build(BuildContext context) {
    final List<String> mediaFiles = [
      ...?postData.images,
      ...?postData.videos,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostItemHeader(
                  postData : postData,
                  onTapMore: (){},
              ),
              SizedBox(height: 5.h),
              PostReactionOverview(itemPost: postData),
              SizedBox(height: 20.h),
              PostTextContent(
                text: postData.title ?? '',
                onTapHashtag: (tag) {
                  print("Hashtag tapped: $tag");
                },
              ),
              if(mediaFiles.isNotEmpty)
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
                        transitionDuration: const Duration(
                          milliseconds: 300,
                        ),
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
                          return FadeTransition(
                            opacity: fade,
                            child: child,
                          );
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
                                        ? ShowVideoWithUrl(videoUrl: mediaFile)
                                        : ShowImageWithUrl(imageUrl: mediaFile),
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
              if(mediaFiles.isEmpty && postData.postLinkMeta?.postLinkUrl != null)
              PostLinkContent(postData: postData)
            ],
          ),
        ),
      ),
    );
  }

  PageRouteBuilder _createCustomRoute(BuildContext context, Widget page) {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
