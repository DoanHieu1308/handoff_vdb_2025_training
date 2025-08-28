import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_resources.dart';

class AppDivider {
  static Widget get v3 => Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    height: 3.h,
    color: ColorResources.LIGHT_GREY,
  );

  static Widget get v5 => Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    height: 5.h,
    color: ColorResources.LIGHT_GREY,
  );

  static Widget get v10 => Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    height: 10.h,
    color: ColorResources.LIGHT_GREY,
  );
}
