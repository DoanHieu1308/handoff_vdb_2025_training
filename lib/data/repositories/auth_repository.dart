import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/helper/validate.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/dio_client.dart';
import 'package:handoff_vdb_2025/data/exception/api_error_handler.dart';
import 'package:handoff_vdb_2025/data/model/auth/auth_model.dart';
import 'package:handoff_vdb_2025/data/model/base/api_response.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';
import '../model/response/user_model.dart';

class AuthRepository {
  final _dio = DioClient();

  AuthRepository();

  ///
  Future<void> signUpEmail({
     required UserModel data,
     required Function(AuthModel data) onSuccess,
     required Function(dynamic error) onError
  }) async{
     Response<dynamic> response;
     dynamic dataLogin;
     dataLogin = data.signUpEmail();
     try{
       response = await _dio.post(EndPoint.SIGN_UP, data: dataLogin);


     } catch (e) {
       onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
       return;
     }
     if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
       final results = response.data as dynamic;
       
       final user = UserModel.fromMap(results['user'] as Map<String, dynamic>);
       AuthModel authModel = AuthModel();
       authModel.user = user;
       authModel.refreshToken = results['refreshToken'].toString();
       authModel.accessToken = results['accessToken'].toString();
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

      final user = UserModel.fromMap(results['user'] as Map<String, dynamic>);
      AuthModel authModel = AuthModel();
      authModel.user = user;
      authModel.refreshToken = results['refreshToken'].toString();
      authModel.accessToken = results['accessToken'].toString();
      onSuccess(authModel);
    }
  }

}