import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/post/post_output_model.dart';
import 'custom_components/custom_icon_interact_post.dart';
import 'custom_components/custom_reaction_like_button.dart';

class PostItemBottomActions extends StatelessWidget {
  final PostOutputModel itemPost;
  const PostItemBottomActions({super.key, required this.itemPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 55.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomReactionLikeButton(itemPost: itemPost),
          CustomIconInteractPost(
            width: 70,
            name: "Bình luận",
            image: ImagesPath.icComment,
          ),
          CustomIconInteractPost(
            width: 70,
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
