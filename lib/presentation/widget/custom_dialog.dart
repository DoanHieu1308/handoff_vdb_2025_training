import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String textNumber1;
  final String textNumber2;
  final VoidCallback? onTapNumber2;
  final VoidCallback? onTapNumber1;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.onTapNumber2,
    this.onTapNumber1,
    required this.textNumber1,
    required this.textNumber2,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 200.h,
        width: 370.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 20.h),
            Text(message, style: TextStyle(fontSize: 14.sp)),
            SizedBox(height: 20.h),
            Container(height: 0.5.h, width: double.infinity, color: Colors.grey),
            SizedBox(height: 20.h),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onTapNumber1,
                    child: SizedBox(
                      width: 70.w,
                      height: 50.h,
                      child: Center(
                        child: Text(
                          textNumber1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: onTapNumber2,
                    child: SizedBox(
                      width: 70.w,
                      height: 50.h,
                      child: Center(
                        child: Text(
                          textNumber2,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
