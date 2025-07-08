import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/data/model/auth/auth_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories_fake/fake_auth_repository.dart';
import 'package:mobx/mobx.dart';
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

  final FakeAuthRepository _repository = FakeAuthRepository();

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
  Future<void> signUp({
    required Function(AuthModel auth) onSuccess,
    required Function(String error) onError,
  }) async {
    if(!validate()) return;

    isLoading = true;
    errorMessage = null;

    final user = UserModel(
      id: "",
      name: name.text.trim(),
      email: email.text.trim(),
      password: password.text.toString().trim(),
      avatar: "assets/features/ic_email.svg",
      bio: "dep trai qua",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now()
    );

    await _repository.signUpEmail(
        data: user,
        onSuccess: (auth) {
          isLoading = false;
          onSuccess(auth);
          print("auth $auth");
          
          // Debug: in ra tất cả users
          _repository.printAllUsers();
          
          // Export dữ liệu ra file gốc (chỉ trong development)
          _repository.exportToOriginalFile();
        },
        onError: (error){
          isLoading = false;
          errorMessage = error.toString();
          onError(errorMessage ?? "An error occurred");
          print("error $error");
        }
    );
  }

}