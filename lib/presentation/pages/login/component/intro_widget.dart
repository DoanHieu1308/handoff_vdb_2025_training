import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/color_resources.dart';

class IntroWiget extends StatelessWidget {
  final String title;
  final String subTitle;
  final int index;
  final String imagesPath;
  const IntroWiget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.index,
    required this.imagesPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtil.getMaxWidth(),
      height: 250.h,
      child: Padding(
        padding: SizeUtil.setEdgeInsetsAll(
            SizeUtil.SPACE_2X
        ),
        child: Column(
          children: [
            Text(title, style: AppText.text16.copyWith(
                color: ColorResources.PRIMARY_TEXT,
                fontFamily: 'Inter-ExtraBold'
            ),textAlign: TextAlign.center,),
            SizedBox(height: 5.h,),
            SetUpAssetImage(
              height: 165.h,
              width: double.infinity,
                imagesPath,
                fit: BoxFit.cover,
            ),
            SizedBox(height: 10.h,),
            Text(subTitle, style: AppText.text12.copyWith(
                color: ColorResources.PRIMARY_TEXT,
                fontFamily: 'Inter-Medium'
            ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}