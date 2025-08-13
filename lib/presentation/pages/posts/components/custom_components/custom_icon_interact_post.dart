import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../../core/helper/app_text.dart';

class CustomIconInteractPost extends StatelessWidget {
  final String name;
  final String image;
  final int width;
  const CustomIconInteractPost({super.key, required this.name, required this.image, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: Row(
        children: [
          SetUpAssetImage(
            height: 20.h,
            width: 15.w,
            image,
            color: Colors.black,
          ),
          SizedBox(width: 2.w),
          Text(name, style: AppText.text10),
        ],
      ),
    );
  }
}
