
import 'package:dio/dio.dart';

import '../../core/helper/validate.dart';
import '../../core/init/app_init.dart';
import '../../core/shared_pref/shared_preference_helper.dart';
import '../../domain/end_points/end_point.dart';
import '../data_source/dio/dio_client.dart';
import '../exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class FollowRepository {
  final DioClient _dio = AppInit.instance.dioClient;
  final SharedPreferenceHelper _sharedPreferenceHelper = AppInit.instance
      .sharedPreferenceHelper;

  FollowRepository() {
    _init();
  }

  Future<void> _init() async {
  }

  ///
  /// unfriend friend
  ///
  Future<void> followFriend ({
    required String friendId,
    required Function() onSuccess,
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
      response = await _dio.post(
          EndPoint.FRIENDS_REQUESTS,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'userId' : friendId,
            'type' : "follow"
          }
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }
  }

  ///
  /// unfriend friend
  ///
  Future<void> unfollowFriend ({
    required String friendId,
    required Function() onSuccess,
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
      response = await _dio.post(
          EndPoint.FRIENDS_REQUESTS,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'userId' : friendId,
            'type' : "unfollow"
          }
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }
  }
}