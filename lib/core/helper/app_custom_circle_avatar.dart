import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';

class AppCustomCircleAvatar extends StatelessWidget {
  final double radius;
  final double height;
  final double width;
  final String image;

  const AppCustomCircleAvatar({
    super.key,
    required this.radius,
    required this.height,
    required this.width,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: SizedBox(
          height: height,
          width: width,
          child: SetUpAssetImage(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
