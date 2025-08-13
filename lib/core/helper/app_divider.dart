import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_resources.dart';

class AppDivider {
  static Widget get v5 => Container(
    margin: EdgeInsets.symmetric(vertical: 5.h),
    height: 1.h,
    color: ColorResources.LIGHT_GREY,
  );

  static Widget get v10 => Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    height: 1.h,
    color: ColorResources.LIGHT_GREY,
  );
}
