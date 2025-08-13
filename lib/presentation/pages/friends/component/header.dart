import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/size_util.dart';
import '../../search/search_page.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10.w,
        left: 10.w,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
              padding: EdgeInsets.all(1),
              height: 50.h,
              width: SizeUtil.getMaxWidth(),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey.shade800
                ),
                borderRadius: BorderRadius.circular(12)
              ),
              child: SearchPage()
          )
      ),
    );
  }
}