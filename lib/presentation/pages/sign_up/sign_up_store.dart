import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/auth_repository.dart';
import 'package:mobx/mobx.dart';

import '../../../data/model/auth/auth_model.dart';
part 'sign_up_store.g.dart';

class SignUpStore = _SignUpStore with _$SignUpStore;

abstract class _SignUpStore with Store {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final focusNodeEmail = FocusNode();
  final focusNodeName = FocusNode();
  final focusNodePassword = FocusNode();
  final focusNodeConfirmPassword = FocusNode();

  /// SharePreference
  final _sharedPreferenceHelper = SharedPreferenceHelper.instance;

  /// Repository
  late final _repository;

  @observable
  bool isLoading = false;

  /// Error
  @observable
  String? errorMessage;

  @observable
  String? nameError;

  @observable
  String? emailError;

  @observable
  String? passwordError;

  @observable
  String? confirmPasswordError;

  ///
  /// Init dio
  ///
  Future<void> init() async {
    _repository = AuthRepository();
  }


  @action
  bool validate() {
    bool isValid = true;

    // Name
    if (name.text.trim().isEmpty){
      nameError = 'Vui long nhap ho va ten';
      isValid = false;
    }else{
      nameError = null;
    }

    // Email
    if (email.text.trim().isEmpty) {
      emailError = 'Vui lòng nhập email';
      isValid = false;
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email.text.trim())) {
      emailError = 'Email không hợp lệ';
      isValid = false;
    } else {
      emailError = null;
    }

    // Password
    if (password.text.isEmpty) {
      passwordError = 'Vui lòng nhập mật khẩu';
      isValid = false;
    } else if (password.text.length < 6) {
      passwordError = 'Mật khẩu tối thiểu 6 ký tự';
      isValid = false;
    } else {
      passwordError = null;
    }

    // Confirm password
    if (confirmPassword.text.isEmpty) {
      confirmPasswordError = 'Vui lòng xác nhận mật khẩu';
      isValid = false;
    } else if (confirmPassword.text != password.text) {
      confirmPasswordError = 'Mật khẩu không khớp';
      isValid = false;
    } else {
      confirmPasswordError = null;
    }
    return isValid;
  }

  @action
  Future<void> testConnection() async {
    isLoading = true;
    errorMessage = null;
    
    try {
      final isConnected = await _repository.testConnection();
      if (isConnected) {
        print('Connection test successful');
      } else {
        print('Connection test failed');
        errorMessage = 'Không thể kết nối đến server';
      }
    } catch (e) {
      print('Connection test error: $e');
      errorMessage = 'Lỗi kết nối: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signUp({
    required Function(AuthModel auth) onSuccess,
    required Function(String error) onError,
  }) async {
    if(!validate()) return;

    isLoading = true;
    errorMessage = null;

    final user = UserModel(
      name: name.text.trim(),
      email: email.text.trim(),
      password: password.text.toString().trim(),
    );

    await _repository.signUpEmail(
        data: user,
        onSuccess: (auth) async {
          isLoading = false;
          _saveLocalData(auth,user);

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
      instance.setEmail(user.email ?? ""),
      instance.setPassword(user.password ?? ""),
    ];

    await Future.wait(futures.whereType<Future<void>>());
    checkSavedData();
  }

  @action
  void checkSavedData() {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    final refreshToken = _sharedPreferenceHelper.getRefreshToken;
    final email = _sharedPreferenceHelper.getEmail;
    final password = _sharedPreferenceHelper.getPassword;
    print("--------Luu token o sign up--------");
    print("accessToken: $accessToken");
    print("refreshToken: $refreshToken");
    print("email: $email");
    print("password: $password");
  }

}