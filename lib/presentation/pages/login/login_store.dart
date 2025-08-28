import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';
import 'package:mobx/mobx.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../data/data_source/dio/dio_client.dart';
import '../../../data/model/auth/auth_model.dart';
import '../../../data/model/response/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../widget/build_snackbar.dart';
import '../home/home_store.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  /// store
  HomeStore get homeStore => AppInit.instance.homeStore;
  ProfileStore get profileStore => AppInit.instance.profileStore;

  /// controller.
  final PageController pageController = PageController(initialPage: 0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Focus
  final passwordFocusNode = FocusNode();
  final emailFocusNode= FocusNode();

  /// SharePreference
  final sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Repository
  final _authRepository = AppInit.instance.authRepository;

  /// Declare the data.
  @observable
  int currentPageIndex = 0;
  @observable
  bool isRemember = true;
  @observable
  String emailSaved = "";
  @observable
  String passwordSaved = "";

  /// Text error
  @observable
  String? emailError;
  @observable
  String? passwordError;
  @observable
  String? errorMessage;


  /// Timer
  Timer? _autoScrollTimer;
  @observable
  bool isLoading = false;


  ///
  /// Init
  ///
  Future<void> init() async {
    emailSaved = sharedPreferenceHelper.getEmail ?? "";
    passwordSaved = sharedPreferenceHelper.getPassword ?? "";
    setTextControl();
  }

  /// Set email, password Controller
  void setTextControl (){
    if(!emailSaved.isEmpty && !passwordSaved.isEmpty){
      emailController.text = emailSaved;
      passwordController.text = passwordSaved;
    }
  }
  /// call in dispose
  void disposeAll() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  /// call in initState
  void startAutoScroll({int pageCount = 3, Duration interval = const Duration(seconds: 3)}) {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(interval, (_) {
      final current = pageController.page!.round();
      final nextPage = (current + 1) % pageCount;

      pageController.animateToPage(
        nextPage,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );

      onChangePageIndex(index: nextPage);
    });
  }

  ///
  /// On change page index.
  ///
  @action
  void onChangePageIndex({required int index}) {
      currentPageIndex = index;
  }

  @action
  void setRemember() {
    isRemember = !isRemember;
  }

  @action
  void goToForgotPassword() {

  }

  @action
  bool validate() {
    bool isValid = true;
    // Email
    if (emailController.text.trim().isEmpty) {
      emailError = 'Vui lòng nhập email';
      isValid = false;
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailController.text.trim())) {
      emailError = 'Email không hợp lệ';
      isValid = false;
    } else {
      emailError = null;
    }

    // Password
    if (passwordController.text.isEmpty) {
      passwordError = 'Vui lòng nhập mật khẩu';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError = 'Mật khẩu tối thiểu 6 ký tự';
      isValid = false;
    } else {
      passwordError = null;
    }
    return isValid;
  }

  @action
  Future<void> logIn({
    required BuildContext context,
    required Function(AuthModel auth) onSuccess,
    required Function(String error) onError,
  }) async {
    if(!validate()) return;

    isLoading = true;
    errorMessage = null;

    final user = UserModel(
      email: emailController.text.trim(),
      password: passwordController.text.toString().trim(),
    );

    await _authRepository.loginEmail(
        data: user,
        onSuccess: (auth) async {
          isLoading = false;
          _saveLocalData(auth, user);

          final args = GoRouterState.of(context).extra as Map<String, dynamic>?;

          if (args != null && args['redirectTo'] == AuthRoutes.CREATE_POST) {
            await profileStore.getUserProfile();
            context.go(args['redirectTo'], extra: args['files']);
          } else {
            await homeStore.getALlPosts(type: PUBLIC);
            context.go(AuthRoutes.DASH_BOARD);
          }

          onSuccess(auth);
        },
        onError: (error){
          isLoading = false;
          errorMessage = error.toString();
          onError(errorMessage ?? "An error occurred");
        }
    );
  }

  Future<void> _saveLocalData(AuthModel auth, UserModel user) async {
    final instance = sharedPreferenceHelper;

    final List<Future<void>?> futures = [
      instance.setAccessToken(auth.accessToken!),
      instance.setRefreshToken(auth.refreshToken!),
      instance.setIdUser(auth.user!.id!),
      if (isRemember) ...[
        instance.setEmail(user.email ?? ""),
        instance.setPassword(user.password ?? ""),
      ] else ...[
        instance.setEmail(""),
        instance.setPassword(""),
      ]
    ];

    await Future.wait(futures.whereType<Future<void>>());


    checkSavedData();
    // await _dio.refreshTokens();
  }


  @action
  void checkSavedData() {
    final accessToken = sharedPreferenceHelper.getAccessToken;
    final refreshToken = sharedPreferenceHelper.getRefreshToken;
    final email = sharedPreferenceHelper.getEmail;
    final password = sharedPreferenceHelper.getPassword;
    final idUser = sharedPreferenceHelper.getIdUser;
    print("accessToken $accessToken");
    print("refreshToken $refreshToken");
    print("email $email");
    print("password $password");
    print("idUser $idUser");
  }
}