import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_store.dart';

import '../../../config/routes/route_path/auth_routers.dart';
import '../../../core/helper/app_text.dart';
import '../../../core/helper/size_util.dart' show SizeUtil;
import '../../../core/utils/images_path.dart';
import '../account/personal_information/widget/auth_input.dart';

class SignUpPage extends StatefulWidget {

  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpStore store = AppInit.instance.signUpStore;
  @override
  void initState() {
    store.init();
    super.initState();
  }

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
              controller: store.name,
              hintText: 'Nhập họ và tên',
              fillColor: ColorResources.COLOR_A4A2A2.withValues(alpha: 0.1),
              prefixIcon: ImagesPath.icUser,
              onNext: () {
                store.focusNodeEmail.requestFocus();
              },
              errorText: store.nameError,
              focusNode:store.focusNodeName,
              onChange: (value) {},
            ),
            SizeUtil.SPACE_2X.verticalSpace,

            // SDT
            AuthInput(
              controller: store.email,
              hintText: 'Nhập email',
              fillColor: ColorResources.COLOR_A4A2A2.withValues(alpha: 0.1),
              prefixIcon: ImagesPath.icEmail,
              onNext: () {
                store.focusNodePassword.requestFocus();
              },
              errorText: store.emailError,
              focusNode: store.focusNodeEmail,
            ),

            SizeUtil.SPACE_2X.verticalSpace,
            // password
            AuthInput(
              isPassword: true,
              fillColor: ColorResources.COLOR_F6F6F7,
              controller: store.password,
              hintText: 'Mật khẩu',
              focusNode: store.focusNodePassword,
              onNext: () {
                store.focusNodeConfirmPassword.requestFocus();
              },
              errorText: store.passwordError,
              prefixIcon: ImagesPath.icPassword,
            ),

            // confirm password
            SizeUtil.SPACE_2X.verticalSpace,
            AuthInput(
              isPassword: true,
              fillColor: ColorResources.COLOR_F6F6F7,
              controller: store.confirmPassword,
              hintText: 'Xác nhận mật khẩu',
              focusNode: store.focusNodeConfirmPassword,
              errorText: store.confirmPasswordError,
              prefixIcon: ImagesPath.icPassword,
            ),
            SizedBox(height: 33.h),
            _buttonSignUp(context),
          ],
        )
    ),
  );

  Widget _buttonSignUp(BuildContext context) => GestureDetector(
    onTap: (){
      store.signUp(onSuccess: (auth){
        context.push(AuthRoutes.LOGIN);
        store.checkSavedData();
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
                context.push(AuthRoutes.LOGIN);
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
