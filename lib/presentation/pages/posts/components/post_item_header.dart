import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/images_path.dart';

class PostItemHeader extends StatelessWidget {
  final PostOutputModel postData;
  final VoidCallback onTapMore;
  const PostItemHeader({super.key, required this.onTapMore, required this.postData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: SetUpAssetImage(
                    postData.userId?.avatar ?? ImagesPath.icPerson,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            flex: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      postData.userId?.name ?? "",
                      style: AppText.text16_bold,
                    ),

                    if (postData.friendsTagged != null && postData.friendsTagged!.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        "- với ",
                        style: AppText.text16,
                      ),

                      // người đầu tiên
                      Text(
                        postData.friendsTagged!.first.name ?? "",
                        style: AppText.text16_bold,
                      ),

                      // còn nhiều hơn 1
                      if (postData.friendsTagged!.length > 1) ...[
                        const SizedBox(width: 4),
                        Text(
                          "và ${postData.friendsTagged!.length - 1} người khác",
                          style: AppText.text16,
                        ),
                      ],
                    ],
                  ],
                ),
                Row(
                  children: [
                    Text("12 giờ", style: AppText.text12),
                    SizedBox(
                      height: 30.h,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 7.h),
                        child: Center(
                          child: Text(" . ", style: AppText.text14),
                        ),
                      ),
                    ),
                    if(postData.privacy == PRIVATE)
                    Icon(
                      Icons.lock  ,
                      color: Colors.black.withOpacity(0.5),
                      size: 15,
                    )
                    else
                      SetUpAssetImage(
                        postData.privacy == PUBLIC ? ImagesPath.icGlobe : ImagesPath.icFriendOutsize,
                        height: 15,
                        width: 15,
                        fit: BoxFit.cover,
                      )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: onTapMore,
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 18.h),
                  child: Center(
                    child: Text(
                      "...",
                      style: AppText.text25_bold.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
