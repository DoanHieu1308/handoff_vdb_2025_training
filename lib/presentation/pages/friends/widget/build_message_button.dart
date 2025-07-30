import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/utils/images_path.dart';

class BuildMessageButton extends StatelessWidget {
  final VoidCallback? onTap;
  BuildMessageButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 23.h,
        width: 23.w,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SetUpAssetImage(
          ImagesPath.icMessenger,
          height: 20.h,
          width: 20.w,
          color: Colors.blue,
        ),
      ),
    );
  }
}
