import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/color_resources.dart';

class ItemFolderProfile extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final bool isSelected;

  const ItemFolderProfile({
    super.key,
    required this.onTap,
    required this.name,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 3.w),
        height: 40.h,
        width: 70.h,
        decoration: BoxDecoration(
            color: isSelected ? ColorResources.COLOR_0956D6.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(name ?? '', style: TextStyle(
              fontSize: 14,
              color: isSelected ? ColorResources.COLOR_0956D6 : Colors.grey,
              fontWeight: FontWeight.w700
          ),),
        ),
      ),
    );
  }
}