import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/app_text.dart';

class BuildActionButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Color? colorText;
  final Color? colorContainer;
  final double? widthSize;
  const BuildActionButton({super.key, required this.onTap, required this.name, this.colorText, this.colorContainer, this.widthSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthSize ?? 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colorContainer ?? Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          name,
          style: AppText.text11_bold.copyWith(color: colorText ?? Colors.white),
        ),
      ),
    );
  }
}
