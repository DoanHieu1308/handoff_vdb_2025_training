import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/response/friend_profile_model.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/helper/validate.dart';
import '../../core/shared_pref/shared_preference_helper.dart';
import '../../domain/end_points/end_point.dart';
import '../data_source/dio/dio_client.dart';
import '../exception/api_error_handler.dart';
import '../model/base/api_response.dart';
import '../model/response/user_model.dart';

class UserRepository {
  final DioClient _dio = AppInit.instance.dioClient;
  late SharedPreferenceHelper _sharedPreferenceHelper;

  UserRepository() {
    _init();
  }

  Future<void> _init() async {
    _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  }

  ///
  /// Get all friends
  ///
  Future<void> getUserProfile ({
    required String userId,
    required Function(UserModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(
          "${EndPoint.USER_PROFILE}/$userId",
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as Map<String, dynamic>;
      final user = metadata['user'] as Map<String, dynamic>;

      final UserModel userFinal = UserModel.fromMap(user);
      onSuccess(userFinal);
    }
  }


  ///
  /// Get all friends
  ///
  Future<void> getFriendProfile ({
    required String userId,
    required Function(FriendProfileModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(
        "${EndPoint.USER_PROFILE}/$userId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as Map<String, dynamic>;

      final FriendProfileModel friendProfile = FriendProfileModel.fromMap(metadata);
      onSuccess(friendProfile);
    }
  }

  ///
  /// Upload Avata
  ///
  Future<void> uploadAvata({
    required String image,
    required Function() onSuccess,
    required Function(dynamic error) onError,
  }) async {
    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    late Response response;
    final formData = FormData.fromMap({
      'type': 'avatar',
      'file': await MultipartFile.fromFile(
        image,
        filename: 'avatar.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    });

    try {
      response =
      await _dio.post(
          EndPoint.UPLOAD_AVATAR,
          data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } catch (e) {
      log('${ApiResponse.withError(ApiErrorHandler.getMessage(e)).error}');
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if (!Validate.nullOrEmpty(response.statusCode) &&
        response.statusCode! >= 200 &&
        response.statusCode! <= 300) {
      // Call back data.
      onSuccess();
    }
  }

}