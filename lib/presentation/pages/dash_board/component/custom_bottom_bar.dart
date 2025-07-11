import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';

import '../../../../core/utils/color_resources.dart';

class CustomBottomBar extends StatefulWidget {
  final VoidCallback? onTap;
  final String imagePath;
  final bool isSelected;
  const CustomBottomBar({super.key, this.onTap, required this.imagePath, required this.isSelected});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(0.0, -25.0),
          child: Transform.scale(
            scale: 1.4,
            child: Container(
              height: 66.h,
              width: 66.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorResources.BACK_GROUND,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0.0, -25.0),
          child: Transform.scale(
            scale: 1.05,
            child: Container(
              height: 66.h,
              width: 66.w,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? ColorResources.COLOR_0956D6.withOpacity(0.1)
                    : ColorResources.COLOR_071A52.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Align(
                child: Transform.scale(
                  scale: 0.8,
                  child: SetUpAssetImage(
                    widget.imagePath,
                    width: 37.w,
                    height: 37.h,
                    color: widget.isSelected
                        ? ColorResources.COLOR_0956D6
                        : ColorResources.COLOR_071A52,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Transform.translate(
            offset: const Offset(0.0, -25.0),
            child: Transform.scale(
              scale: 1.7,
              child: Container(
                height: 66.h,
                width: 66.w,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

