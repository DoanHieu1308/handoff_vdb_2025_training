import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';

import '../../../../core/helper/app_text.dart';


class PostTextBody extends StatelessWidget {
  const PostTextBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE91E63), Color(0xFF2196F3)],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: SizeUtil.getMaxWidth() - 50.w,
          child: Text(
              "Hôm nay trời đẹp thế nhờ. Hú Hú",
              style: AppText.text28_bold.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
