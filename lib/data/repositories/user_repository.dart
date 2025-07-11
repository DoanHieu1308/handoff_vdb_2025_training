import 'package:dio/dio.dart';

import '../../core/helper/validate.dart';
import '../../core/shared_pref/shared_preference_helper.dart';
import '../../domain/end_points/end_point.dart';
import '../data_source/dio/dio_client.dart';
import '../exception/api_error_handler.dart';
import '../model/base/api_response.dart';
import '../model/response/user_model.dart';

class UserRepository {
  late DioClient _dio;
  SharedPreferenceHelper? _sharedPreferenceHelper;

  UserRepository() {
    _init();
  }

  Future<void> _init() async {
    _dio = DioClient();
    _sharedPreferenceHelper = SharedPreferenceHelper.instance;
  }

  ///
  /// Get all friends
  ///
  Future<void> getUserProfile ({
    required Function(UserModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(EndPoint.USER_PROFILE);
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

}