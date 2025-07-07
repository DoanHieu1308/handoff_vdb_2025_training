import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_store.dart';

import '../../../config/routes/route_path/auth_routers.dart';
import '../../../core/helper/app_text.dart';
import '../../../core/helper/size_util.dart' show SizeUtil;
import '../../../core/utils/images_path.dart';
import '../account/personal_information/widget/auth_input.dart';

class SignUpPage extends StatefulWidget {
  SignUpStore store = SignUpStore();
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.WHITE,
      bottomNavigationBar: _anotherSignIn(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _logo(),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buidWidgetSingupFileds(context),
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _logo() => Column(
    children: [
      Center(
        child: SetUpAssetImage(
          ImagesPath.imgSignUp,
          width: SizeUtil.setSizeWithWidth(percent: .5),
        ),
      ),
      SizedBox(height: 20.h),
      Text(
        'Đăng ký tài khoản',
        style: TextStyle(fontWeight: FontWeight.w500, color: ColorResources.BLACK, fontSize: 24.sp),
      ),
    ],
  );

  Widget _buidWidgetSingupFileds(BuildContext context) => Padding(
    padding: SizeUtil.setEdgeInsetsAll(SizeUtil.SPACE_3X),
    child: Observer(
        builder: (_) => Column(
          children: [
            // name
            AuthInput(
              controller: widget.store.name,
              hintText: 'Nhập họ và tên',
              fillColor: ColorResources.COLOR_A4A2A2.withValues(alpha: 0.1),
              prefixIcon: ImagesPath.icUser,
              onNext: () {
                widget.store.focusNodeEmail.requestFocus();
              },
              errorText: widget.store.nameError,
              focusNode: widget.store.focusNodeName,
              onChange: (value) {},
            ),
            SizeUtil.SPACE_2X.verticalSpace,

            // SDT
            AuthInput(
              controller: widget.store.email,
              hintText: 'Nhập email',
              fillColor: ColorResources.COLOR_A4A2A2.withValues(alpha: 0.1),
              prefixIcon: ImagesPath.icEmail,
              onNext: () {
                widget.store.focusNodePassword.requestFocus();
              },
              errorText: widget.store.emailError,
              focusNode: widget.store.focusNodeEmail,
            ),

            SizeUtil.SPACE_2X.verticalSpace,
            // password
            AuthInput(
              isPassword: true,
              fillColor: ColorResources.COLOR_F6F6F7,
              controller: widget.store.password,
              hintText: 'Mật khẩu',
              focusNode: widget.store.focusNodePassword,
              onNext: () {
                widget.store.focusNodeConfirmPassword.requestFocus();
              },
              errorText: widget.store.passwordError,
              prefixIcon: ImagesPath.icPassword,
            ),

            // confirm password
            SizeUtil.SPACE_2X.verticalSpace,
            AuthInput(
              isPassword: true,
              fillColor: ColorResources.COLOR_F6F6F7,
              controller: widget.store.confirmPassword,
              hintText: 'Xác nhận mật khẩu',
              focusNode: widget.store.focusNodeConfirmPassword,
              errorText: widget.store.confirmPasswordError,
              prefixIcon: ImagesPath.icPassword,
            ),
            SizedBox(height: 33.h),
            _buttonSignUp(context),
          ],
        )
    ),
  );

  // TODO
  // Dang co bug
  Widget _buttonSignUp(BuildContext context) => GestureDetector(
    onTap: (){
      // showDialog(
      //   context: context,
      //   builder: (_) => Dialog(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12)
      //     ),
      //     child: Container(
      //       padding: EdgeInsets.all(20),
      //       height: 200.h,
      //       width: 370.w,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           SizedBox(
      //             height: 10.h,
      //           ),
      //           Text('${widget.store.email.text.trim()}', style: AppText.text14_Inter),
      //           SizedBox(
      //             height: 20.h,
      //           ),
      //           Text('You are about to unfriend Quốc Thuỷ. Are you sure you want to proceed?', style: AppText.text12),
      //           SizedBox(
      //             height: 20.h,
      //           ),
      //           Container(
      //             height: 0.5.h,
      //             width: 370.w,
      //             color: Colors.grey,
      //           ),
      //           SizedBox(
      //             height: 20.h,
      //           ),
      //           Expanded(
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.end,
      //                 children: [
      //                   GestureDetector(
      //                     onTap: (){
      //                       Navigator.pop(context);
      //                     },
      //                     child: SizedBox(
      //                       width: 70.w,
      //                       height: 50.h,
      //                       child: Center(
      //                         child: Text("Cancel", style: TextStyle(
      //                             color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500
      //                         ),),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     width: 10.w,
      //                   ),
      //                   Builder(
      //                       builder: (scaffoldContext) {
      //                         return GestureDetector(
      //                           onTap: (){
      //                             ScaffoldMessenger.of(context).showSnackBar(
      //                               SnackBar(
      //                                 backgroundColor: Colors.transparent,
      //                                 elevation: 0,
      //                                 behavior: SnackBarBehavior.floating,
      //                                 duration: Duration(seconds: 4),
      //                                 content: Container(
      //                                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //                                   decoration: BoxDecoration(
      //                                     color: Colors.white,
      //                                     borderRadius: BorderRadius.circular(12),
      //                                     boxShadow: [
      //                                       BoxShadow(
      //                                         color: Colors.black.withOpacity(0.15),
      //                                         blurRadius: 6,
      //                                         offset: Offset(0, 2),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                   child: Row(
      //                                     children: [
      //                                       Icon(Icons.check_circle, color: Colors.green, size: 24),
      //                                       SizedBox(width: 12),
      //                                       Expanded(
      //                                         child: Text(
      //                                           "Successfully unfriended",
      //                                           style: TextStyle(
      //                                             fontSize: 15,
      //                                             color: Colors.black,
      //                                           ),
      //                                         ),
      //                                       ),
      //                                       TextButton(
      //                                         onPressed: () {
      //                                         },
      //                                         child: Text("Undo"),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ),
      //                             );
      //                             Navigator.pop(context);
      //                             Navigator.pop(context);
      //                           },
      //                           child: SizedBox(
      //                             width: 70.w,
      //                             height: 50.h,
      //                             child: Center(
      //                               child: Text("Confirm", style: TextStyle(
      //                                   color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500
      //                               ),),
      //                             ),
      //                           ),
      //                         );
      //                       }
      //                   )
      //                 ],
      //               )
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // );

      widget.store.signUp(onSuccess: (auth){
        Navigator.of(context).pushNamed(AuthRouters.LOGIN);
      }, onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      });
    },
    child: Container(
      height: 44.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: ColorResources.MAIN, borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text("Đăng ký", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
      ),
    ),
  );

  Widget _anotherSignIn() => Padding(
    padding: SizeUtil.setEdgeInsetsOnly(left: 40.w, right: 40.w, bottom: 20.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bạn đã có tài khoản?',
              style: AppText.text12.copyWith(
                color: ColorResources.BLACK,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AuthRouters.LOGIN);
              },
              child: Text(
                ' Đăng nhập ngay',
                style: AppText.text12.copyWith(
                  color: ColorResources.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 0.25, // Height of the line
          color: ColorResources.COLOR_A4A2A2,
          margin: EdgeInsets.symmetric(vertical: 6.h),
        ),
        GestureDetector(
          onTap: () {
          },
          child: Text(
            'Trải nghiệm không cần đăng nhập',
            style: AppText.text12.copyWith(
              color: ColorResources.WARRING_ALERT,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
