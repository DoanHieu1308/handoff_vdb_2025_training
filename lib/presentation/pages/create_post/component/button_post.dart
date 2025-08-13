import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/color_resources.dart';

class ButtonPost extends StatelessWidget {
  final bool hasdata;
  final String name;
  const ButtonPost({
    super.key,
    required this.name,
    required this.hasdata,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 35.h,
        width: 70.w,
        decoration: BoxDecoration(
          color: hasdata ? Colors.indigoAccent : ColorResources.LIGHT_GREY.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: AppText.text14_bold.copyWith(
              color: hasdata ? Colors.white : Colors.black.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}