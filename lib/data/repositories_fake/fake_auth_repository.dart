import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../exception/api_error_handler.dart';
import '../model/auth/auth_model.dart';
import '../model/base/api_response.dart';
import '../model/response/user_model.dart';


class FakeAuthRepository {
  List<UserModel> _fakeUsers = [];

  bool _hasLoaded = false;

  Future<File> _getUserFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  Future<void> _initUserFile() async {
    final file = await _getUserFile();
    if (!(await file.exists())) {
      final data = await rootBundle.loadString('lib/data/data_fake/users.json');
      await file.writeAsString(data);
    }
  }

  Future<void> loadUserFromJson() async {
    if (_hasLoaded) return;
    await _initUserFile();

    final file = await _getUserFile();
    final content = await file.readAsString();
    final jsonData = json.decode(content) as List<dynamic>;

    _fakeUsers = jsonData.map((e) => UserModel.fromMap(e)).toList();
    _hasLoaded = true;
  }

  Future<void> _saveUsersToJson() async {
    final file = await _getUserFile();
    final content = json.encode(_fakeUsers.map((u) => u.toMap()).toList());
    await file.writeAsString(content);
  }


  /// Fake sign up
  Future<void> signUpEmail({
    required UserModel data,
    required Function(AuthModel data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    try {
      await loadUserFromJson();

      // Check if email already exists
      final existing = _fakeUsers.any((user) => user.email == data.email);
      if (existing) {
        onError("Email already exists.");
        return;
      }

      // Fake server processing delay
      await Future.delayed(Duration(milliseconds: 500));

      // Create new user
      final newUser = data.copyWith(
        id: "u${_fakeUsers.length + 1}".padLeft(4, '0'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _fakeUsers.add(newUser);

      await _saveUsersToJson();

      final authModel = AuthModel(
        user: newUser,
        accessToken: "fake-access-token-${newUser.id}",
        refreshToken: "fake-refresh-token-${newUser.id}",
      );

      onSuccess(authModel);
    } catch (e) {
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
    }
  }
}
