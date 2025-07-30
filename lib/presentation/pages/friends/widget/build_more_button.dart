import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';

import '../../../../core/utils/images_path.dart';
import '../../item_detail/item_detail_page.dart';

class BuildMoreButton extends StatelessWidget {
  final String categoryName;
  final UserModel friend;
  const BuildMoreButton({super.key, required this.friend, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.8,
          child: ItemDetailPage(
            categoryName: categoryName,
            friend: friend,
          ),
        ),
      ),
      child: Container(
        width: 30.w,
        height: 30.h,
        color: Colors.transparent,
        child: Image.asset(
          ImagesPath.ic3Dot,
          height: 20.h,
          width: 20.h,
        ),
      ),
    );
  }
}
