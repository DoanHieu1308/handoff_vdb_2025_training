import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import '../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../core/helper/app_text.dart';
import '../../../core/helper/size_util.dart';
import '../../../core/utils/images_path.dart';
import 'components/post_item_bottom_actions.dart';
import 'components/post_item_header.dart';
import 'components/post_image_video_content.dart';
import 'components/post_link_content.dart';
import 'components/post_item_header_actions.dart';
import 'components/post_reaction_overview.dart';
import 'components/post_text_content.dart';

class PostItem extends StatelessWidget {
  final PostOutputModel itemPost;
  const PostItem({super.key, required this.itemPost});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtil.getMaxWidth(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          PostItemHeader(
            postData: itemPost,
            onTapMore: (){
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context){
                    return PostItemHeaderActions(itemPost: itemPost);
                  }
              );
            },
          ),
          SizedBox(height: 10.h),
          PostTextContent(
            text: itemPost.title ?? '',
            onTapHashtag: (tag) {
              print("Hashtag tapped: $tag");
            },
          ),
          SizedBox(height: 10.h),
          if(itemPost.images!.isEmpty && itemPost.videos!.isEmpty && itemPost.postLinkMeta != null)
          PostLinkContent(postData: itemPost),
          if(itemPost.images!.isNotEmpty || itemPost.videos!.isNotEmpty)
          GestureDetector(
              onTap: (){
                context.push(
                    AuthRoutes.SHOW_ALL_IMAGE,
                    extra: itemPost,
                );
              },
              child: PostImageVideoContent(postData: itemPost)
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: PostReactionOverview(postData: itemPost,),
          ),
          PostItemBottomActions(itemPost: itemPost),
          Container(height: 3.h, color: Colors.grey.withOpacity(0.3)),
        ],
      ),
    );
  }
}
