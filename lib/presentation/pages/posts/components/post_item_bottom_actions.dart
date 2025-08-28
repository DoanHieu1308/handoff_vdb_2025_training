import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/components/content_item_buttom_actions/comment/comments_view.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/post_item_store.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/post/post_output_model.dart';
import 'custom_components/custom_icon_interact_post.dart';
import 'custom_components/custom_reaction_like_button.dart';

class PostItemBottomActions extends StatelessWidget {
  final PostItemStore postItemStore = AppInit.instance.postItemStore;
  final PostOutputModel itemPost;

  PostItemBottomActions({super.key, required this.itemPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 55.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTapAnimation(
            enabled: true,
              onTap: (){},
              child: CustomReactionLikeButton(itemPost: itemPost),
          ),
          AppTapAnimation(
            enabled: true,
            onTap: (){
              postItemStore.getCommentByPostId(commentPostId: itemPost.id ?? "")
                  .then((_) async {
                postItemStore.isShowBottomSheet = true;
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  transitionAnimationController: AnimationController(
                    vsync: Navigator.of(context),
                    duration: const Duration(milliseconds: 700),
                    reverseDuration: const Duration(milliseconds: 400),
                  ),
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.94,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: CommentsView(itemPost: itemPost),
                    ),
                  ),
                );

                postItemStore.isShowBottomSheet = false;
                postItemStore.commentList.clear();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomIconInteractPost(
                width: 70,
                name: "Bình luận",
                image: ImagesPath.icComment,
              ),
            ),
          ),
          CustomIconInteractPost(
            width: 70,
            imageHeight: 18.h,
            name: "Nhắn tin",
            image: ImagesPath.icMessenger,
          ),
          CustomIconInteractPost(
            width: 70,
            name: "Chia sẻ",
            image: ImagesPath.icShare,
          ),
        ],
      ),
    );
  }
}
