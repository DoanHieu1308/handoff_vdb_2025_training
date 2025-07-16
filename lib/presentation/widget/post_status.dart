import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/base_widget/images/set_up_asset_image.dart';
import '../../core/helper/app_text.dart';
import '../../core/utils/images_path.dart';
import 'item_post_widget.dart';

class PostStatus extends StatelessWidget {
  const PostStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            height: 3.h,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: CircleAvatar(
                    radius: 30,
                    child: SetUpAssetImage(
                      height: 35.h,
                      width: 35.w,
                      ImagesPath.icPerson,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  flex: 16,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Đoàn Hiếu",
                        style: AppText.text16_bold,
                      ),
                      Row(
                        children: [
                          Text(
                            "12 giờ",
                            style: AppText.text12,
                          ),
                          SizedBox(
                            height: 30.h,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 7.h,
                              ),
                              child: Center(
                                child: Text(
                                  " . ",
                                  style: AppText.text14,
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock,
                            color: Colors.black.withOpacity(
                              0.5,
                            ),
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 18.h,
                      ),
                      child: Center(
                        child: Text(
                          "...",
                          style: AppText.text25_bold
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(height: 300.h, color: Colors.green),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            height: 55.h,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ItemPostWidget(
                    width: 60,
                    name: "Thích",
                    image: ImagesPath.icLike
                ),
                ItemPostWidget(
                    width: 70,
                    name: "Bình luận",
                    image: ImagesPath.icComment
                ),
                ItemPostWidget(
                    width: 70,
                    name: "Nhắn tin",
                    image: ImagesPath.icMessenger
                ),
                ItemPostWidget(
                    width: 70,
                    name: "Chia sẽ",
                    image: ImagesPath.icShare
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}