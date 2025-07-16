import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/helper/validate.dart';
import 'package:handoff_vdb_2025/data/exception/api_error_handler.dart';
import 'package:handoff_vdb_2025/data/model/auth/auth_model.dart';
import 'package:handoff_vdb_2025/data/model/base/api_response.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';
import '../data_source/dio/dio_client.dart';
import '../model/response/user_model.dart';

class AuthRepository {
  late final DioClient _dio;

  AuthRepository() {
    _dio = DioClient();
  }

  ///
  /// Test connection to API server
  ///
  Future<bool> testConnection() async {
    try {
      await _dio.get('/');
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  ///
  Future<void> signUpEmail({
     required UserModel data,
     required Function(AuthModel data) onSuccess,
     required Function(dynamic error) onError
  }) async{
     Response<dynamic> response;
     dynamic dataLogin = data.signUpEmail();
     try{
       response = await _dio.post(EndPoint.SIGN_UP, data: dataLogin);
     } catch (e) {
       print("Error details: $e");
       onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
       return;
     }
     if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
       final results = response.data as Map<String, dynamic>;

       final metadatas = results['metadata'] as Map<String, dynamic>;
       final shopData = metadatas['shop'] as Map<String, dynamic>;
       final tokens = metadatas['tokens']  != null ? metadatas['tokens'] as Map<String, dynamic> : null;

       final user = UserModel.fromMap(shopData);

       AuthModel authModel = AuthModel();
       authModel.user = user;
       authModel.refreshToken = tokens?['refreshToken'].toString();
       authModel.accessToken = tokens?['accessToken'].toString();

       onSuccess(authModel);
     }
  }

  Future<void> loginEmail({
    required UserModel data,
    required Function(AuthModel data) onSuccess,
    required Function(dynamic error) onError
  }) async{
    Response<dynamic> response;
    dynamic dataLogin;
    dataLogin = data.loginEmail();
    try{
      response = await _dio.post(EndPoint.LOGIN, data: dataLogin);
    } catch (e) {
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as dynamic;

      final metadatas = results['metadata'] as Map<String, dynamic>;
      final shopData = metadatas['shop'] as Map<String, dynamic>;
      final tokens = metadatas['tokens']  != null ? metadatas['tokens'] as Map<String, dynamic> : null;

      final user = UserModel.fromMap(shopData);

      AuthModel authModel = AuthModel();
      authModel.user = user;
      authModel.refreshToken = tokens?['refreshToken'].toString();
      authModel.accessToken = tokens?['accessToken'].toString();
      onSuccess(authModel);
    }
  }

  Future<void> logout({
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async{
    Response<dynamic> response;
    try{
      response = await _dio.post(EndPoint.LOGOUT);
    } catch (e) {
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }
  }


}