import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';
import 'package:mobx/mobx.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../data/model/auth/auth_model.dart';
import '../../../data/model/response/user_model.dart';
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

  /// Firebase
  final firebasePresenceService = AppInit.instance.firebasePresenceService;

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
  
  /// Xử lý logout và cleanup Firebase presence
  @action
  Future<void> logout() async {
    try {
      // Cleanup Firebase presence

      // Sign out khỏi Firebase Auth
      try {
        await FirebaseAuth.instance.signOut();
        print('LoginStore: Firebase Auth sign out successful');
      } catch (e) {
        print('LoginStore: Error signing out from Firebase Auth: $e');
      }
      
      // Clear local data
      await sharedPreferenceHelper.clearAuthData();
      
      print('LoginStore: Logout completed successfully');
    } catch (e) {
      print('LoginStore: Error during logout: $e');
    }
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
            if (context.mounted) {
              context.go(args['redirectTo'], extra: args['files']);
            }
          } else {
            await homeStore.getALlPosts(type: PUBLIC);
            if (context.mounted) {
              context.go(AuthRoutes.DASH_BOARD);
            }
          }
          await profileStore.getUserProfile();
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

    try {
      await _createFirebaseAuthUser(user);
    } catch (e) {
      print('Error creating Firebase Auth user: $e');
    }

    try {
      firebasePresenceService.setupUserPresence(auth.user?.id ?? "");
    } catch (e) {
      print('Error initializing Firebase Presence Service: $e');
    }

    checkSavedData();
  }
  
  /// Tạo Firebase Auth user để có thể bắt sự kiện online/offline
  Future<void> _createFirebaseAuthUser(UserModel user) async {
    try {
      final auth = FirebaseAuth.instance;
      
      // Kiểm tra xem đã có user đang đăng nhập không
      if (auth.currentUser != null) {
        print('Firebase Auth user already exists: ${auth.currentUser!.uid}');
        return;
      }
      
      // Tạo anonymous user hoặc sign in với email/password
      // Sử dụng email từ BE API và tạo password tạm thời
      final email = user.email ?? 'user_${user.id}@handoff.com';
      final password = 'temp_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
      
      try {
        // Thử tạo user mới
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('Firebase Auth user created: ${userCredential.user?.uid}');
      } catch (e) {
        if (e.toString().contains('email-already-in-use')) {
          // Nếu email đã tồn tại, thử sign in
          final userCredential = await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          print('Firebase Auth user signed in: ${userCredential.user?.uid}');
        } else {
          // Nếu không thể tạo hoặc sign in, tạo anonymous user
          final userCredential = await auth.signInAnonymously();
          print('Firebase Auth anonymous user created: ${userCredential.user?.uid}');
        }
      }
    } catch (e) {
      print('Error in Firebase Auth user creation: $e');
      // Fallback: tạo anonymous user
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        print('Firebase Auth anonymous user created as fallback: ${userCredential.user?.uid}');
      } catch (fallbackError) {
        print('Error creating anonymous user: $fallbackError');
      }
    }
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