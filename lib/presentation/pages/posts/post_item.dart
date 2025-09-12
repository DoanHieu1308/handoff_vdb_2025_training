import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/post_item_store.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../core/helper/size_util.dart';
import 'components/post_item_bottom_actions.dart';
import 'components/post_item_header.dart';
import 'components/post_image_video_content.dart';
import 'components/post_link_content.dart';
import 'components/post_item_header_actions.dart';
import 'components/post_reaction_overview.dart';
import 'components/post_text_content.dart';

class PostItem extends StatefulWidget {
  final PostOutputModel itemPost;
  const PostItem({super.key, required this.itemPost});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> with AutomaticKeepAliveClientMixin{
  final PostItemStore postItemStore = AppInit.instance.postItemStore;
  @override
  void initState() {
    super.initState();
    postItemStore.init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    try {
      return Container(
        width: SizeUtil.getMaxWidth(),
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            PostItemHeader(
              postData: widget.itemPost,
              onTapMore: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context){
                      return PostItemHeaderActions(itemPost: widget.itemPost);
                    }
                );
              },
            ),
            GestureDetector(
              onTap: (){
                context.push(
                  AuthRoutes.SHOW_ALL_IMAGE,
                  extra: widget.itemPost,
                );
              },
              child: Container(
                color: Colors.transparent,
                width: SizeUtil.getMaxWidth(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    PostTextContent(
                      text: widget.itemPost.title ?? '',
                      onTapHashtag: (tag) {
                        print("Hashtag tapped: $tag");
                      },
                    ),
                    SizedBox(height: 10.h),
                    if(widget.itemPost.images!.isEmpty && widget.itemPost.videos!.isEmpty && widget.itemPost.postLinkMeta != null)
                      PostLinkContent(postData: widget.itemPost),
                    if(widget.itemPost.images!.isNotEmpty || widget.itemPost.videos!.isNotEmpty)
                      PostImageVideoContent(postData: widget.itemPost),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: PostReactionOverview(
                key: ValueKey('${widget.itemPost.id}'),
                itemPost: widget.itemPost,
              ),
            ),
            PostItemBottomActions(itemPost: widget.itemPost),
            Container(height: 3.h, color: Colors.grey.withOpacity(0.3)),
          ],
        ),
      );
    } catch (e) {
      // Fallback widget if there's an error
      return Container(
        width: SizeUtil.getMaxWidth(),
        height: 100,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text(
            'Lỗi hiển thị bài viết',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => false;
}
