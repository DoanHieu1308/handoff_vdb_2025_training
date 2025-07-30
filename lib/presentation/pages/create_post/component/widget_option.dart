import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';


class WidgetOption extends StatelessWidget {
  final String name;
  final String icon;
  final Function()? onTap;
  const WidgetOption({super.key, required this.name, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(5)
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Row(
          mainAxisSize : MainAxisSize.min,
          spacing: 4,
          children: [
            SetUpAssetImage(
              icon,
              height: 13.h,
              width: 13.w,
              color: Colors.indigo,
            ),
            Text(name, style: AppText.text12_bold.copyWith(color: Colors.indigo),),
            Icon(Icons.expand_more, size: 15, color: Colors.indigo,)
          ],
        ),
      ),
    );
  }
}
