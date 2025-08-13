import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/post/post_output_model.dart';

class PostReactionOverview extends StatelessWidget {
  final PostOutputModel postData;
  const PostReactionOverview({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: 25.h,
        width: SizeUtil.getMaxWidth(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 17.h,
                    width: 17.w,
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SetUpAssetImage(
                        ImagesPath.icLike,
                        height: 13.h,
                        width: 13.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text("12,8k", style: AppText.text11),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child:
                postData.comments != 0
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(postData.comments.toString() ?? '', style: AppText.text12),
                    const SizedBox(width: 3),
                    Text("bình luận", style: AppText.text11),
                  ],
                )
                    : SizedBox()
            ),
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("88", style: AppText.text12),
                  const SizedBox(width: 3),
                  Text("lượt chia sẻ", style: AppText.text11),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("12k", style: AppText.text12),
                  const SizedBox(width: 3),
                  Text("lượt xem", style: AppText.text11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
