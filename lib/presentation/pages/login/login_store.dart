import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:mobx/mobx.dart';
import '../../../data/data_source/dio/dio_client.dart';
import '../../../data/model/auth/auth_model.dart';
import '../../../data/model/response/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../widget/build_snackbar.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  /// Dio
  final DioClient _dio = AppInit.instance.dioClient;

  /// controller.
  final PageController pageController = PageController(initialPage: 0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Focus
  final passwordFocusNode = FocusNode();
  final emailFocusNode= FocusNode();

  /// SharePreference
  final _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Repository
  late final _repository;

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


  _LoginStore () {
    _init();
  }

  ///
  /// Init
  ///
  Future<void> _init() async {
    // Get dependencies directly
    _repository = AuthRepository();

    emailSaved = _sharedPreferenceHelper.getEmail ?? "";
    passwordSaved = _sharedPreferenceHelper.getPassword ?? "";

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

    await _repository.loginEmail(
        data: user,
        onSuccess: (auth) async {
          isLoading = false;
          _saveLocalData(auth, user);

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
    final instance = _sharedPreferenceHelper;

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
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    final refreshToken = _sharedPreferenceHelper.getRefreshToken;
    final email = _sharedPreferenceHelper.getEmail;
    final password = _sharedPreferenceHelper.getPassword;
    final idUser = _sharedPreferenceHelper.getIdUser;
    print("accessToken $accessToken");
    print("refreshToken $refreshToken");
    print("email $email");
    print("password $password");
    print("idUser $idUser");
  }
}