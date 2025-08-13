import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/base_widget/lazy_index_stack.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_store.dart';
import '../../../core/helper/app_text.dart';
import '../../../core/helper/size_util.dart';
import '../../../core/init/app_init.dart';
import '../../../core/utils/color_resources.dart';
import '../../../core/utils/images_path.dart';
import '../../widget/build_snackbar.dart';
import '../account/personal_information/widget/auth_input.dart';
import 'component/intro_widget.dart';

class LoginPage extends StatefulWidget {
  late LoginStore store = LoginStore();
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    widget.store.init();
    widget.store.startAutoScroll();
    super.initState();
  }

  @override
  void dispose() {
    widget.store.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFAF3),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Đăng nhập",
                  style: AppText.text30.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: SizeUtil.SPACE_2X),
                Padding(
                  padding: SizeUtil.setEdgeInsetsSymmetric(
                    horizontal: SizeUtil.SPACE_3X,
                  ),
                  child: Text(
                    'Chào mừng bạn đến với \nHANDOFF',
                    style: AppText.text18.copyWith(
                      color: ColorResources.COLOR_464647,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 17.h),
                Container(
                  height: 295.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(child: _bodyIntro()),
                      _dotButton(),
                    ],
                  ),
                ),
              ],
            ),
            _buildBodyLogin(context),
          ],
        ),
      ),
    );
  }

  Observer _buildBodyLogin(BuildContext context) {
    return Observer(
      builder:
          (_) => Column(
            children: [
              Spacer(),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorResources.WHITE,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffE3E3E3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đăng nhập bằng email',
                      style: AppText.text16.copyWith(
                        color: ColorResources.BLACK,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    AuthInput(
                      controller: widget.store.emailController,
                      hintText: 'Email',
                      fillColor: ColorResources.COLOR_F6F6F7,
                      prefixIcon: ImagesPath.icEmail,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      errorText: widget.store.emailError,
                      onNext: () => widget.store.passwordFocusNode.requestFocus(),
                      focusNode: widget.store.emailFocusNode,
                    ),
                    const SizedBox(height: SizeUtil.SPACE_3X),
                    AuthInput(
                      isPassword: true,
                      fillColor: ColorResources.COLOR_F6F6F7,
                      controller: widget.store.passwordController,
                      hintText: 'Mật khẩu',
                      focusNode: widget.store.passwordFocusNode,
                      errorText: widget.store.passwordError,
                      prefixIcon: ImagesPath.icPassword,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        InkWell(
                          onTap: widget.store.setRemember,
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              color:
                              widget.store.isRemember
                                      ? ColorResources.MAIN
                                      : Colors.transparent,
                              border: Border.all(color: ColorResources.MAIN),
                              borderRadius: BorderRadius.circular(6.h),
                            ),
                            child:
                            widget.store.isRemember
                                    ? Icon(
                                      Icons.check,
                                      size: 10.w,
                                      color: ColorResources.WHITE,
                                    )
                                    : null,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Ghi nhớ tài khoản',
                          style: AppText.text14.copyWith(
                            color: ColorResources.COLOR_464647,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Quên mật khẩu?',
                            style: AppText.text14.copyWith(
                              color: ColorResources.MAIN,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                          onTap: () {
                        widget.store.logIn(
                            onSuccess: (auth) {
                              AppInit.instance.dashBoardStore.onChangedDashboardPage(index: 0);
                              context.go(AuthRoutes.DASH_BOARD);
                              widget.store.checkSavedData();
                            },
                            onError: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                buildSnackBarNotifyError(
                                  textNotify: error,
                                ),
                              );
                              print("Login loi : $error");
                            }
                        );
                      },
                      child: Container(
                        height: 44.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorResources.MAIN,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Observer _dotButton() {
    return Observer(
        builder: (_) => Padding(
          padding: EdgeInsets.only(left: 300, bottom: 13.h),
          child: SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ...List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.only(
                          left: index != 0 ? SizeUtil.SPACE_1X : 0,
                        ),
                        height: 8,
                        width: widget.store.currentPageIndex == index ? 25 : 10,
                        decoration: BoxDecoration(
                          color:
                          widget.store.currentPageIndex == index
                              ? ColorResources.MAIN
                              : Colors.grey,
                          shape:
                          widget.store.currentPageIndex == index
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          borderRadius:
                          widget.store.currentPageIndex == index
                              ? BorderRadius.circular(100)
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _bodyIntro() {
    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: PageView.builder(
          onPageChanged: (value) {
            widget.store.onChangePageIndex(index: value);
          },
          controller: widget.store.pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return LazyIndexedStack(
              index: index,
              children: [
                IntroWiget(
                  index: index,
                  title: "Page1",
                  subTitle: "Page1",
                  imagesPath: ImagesPath.icEmail,
                ),
                IntroWiget(
                  index: index,
                  title: "Page1",
                  subTitle: "Page1",
                  imagesPath: ImagesPath.icMessenger,
                ),
                IntroWiget(
                  index: index,
                  title: "Page1",
                  subTitle: "Page1",
                  imagesPath: ImagesPath.icHome,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
