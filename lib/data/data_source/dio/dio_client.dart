import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/logging_interceptor.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';
import '../../../core/shared_pref/shared_preference_helper.dart';

class DioClient {
  late SharedPreferenceHelper _sharedPreferenceHelper;
  Dio? dio;
  String? token;
  LoggingInterceptor? loggingInterceptor;
  bool _isInitialized = false;

  DioClient(){
    _init();
  }

  ///
 /// Init dio
 ///
 Future<void> _init() async {
    dio = Dio();
    _sharedPreferenceHelper = SharedPreferenceHelper.instance;
    
    String? jwtToken = _sharedPreferenceHelper.getAccessToken;

    dio!
      ..options.baseUrl = EndPoint.BASE_URL
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (jwtToken != null && jwtToken.isNotEmpty)
          'Cookie': 'accessToken=$jwtToken',
      };
    dio!.interceptors.add(LoggingInterceptor());
    _isInitialized = true;
 }

  ///
  /// Ensure initialization is complete
  ///
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _init();
    }
  }

  ///
  /// Refresh token
  ///
  Future<void> refreshToken() async {
    final String? refreshToken = _sharedPreferenceHelper.getRefreshToken;
    
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        final response = await dio!.post(
          EndPoint.REFRESH_TOKEN,
          data: {'refreshToken': refreshToken},
        );
        
        if (response.statusCode == 200) {
          final results = response.data as dynamic;

          final metadatas = results['metadata'] as Map<String, dynamic>;
          final tokens = metadatas['tokens']  != null ? metadatas['tokens'] as Map<String, dynamic> : null;

          final newAccessToken = tokens?['accessToken'].toString();
          if (newAccessToken != null) {
            await _sharedPreferenceHelper.setAccessToken(newAccessToken);
            
            print("_____newAccessToken___$newAccessToken}");
            // Update headers with new token
            _updateAuthorizationHeader(newAccessToken);
          }
        }
      } catch (e) {
        print('Token refresh failed: $e');
        // If refresh fails, clear all auth data
        await _sharedPreferenceHelper.clearAuthData();
      }
    }
  }

  ///
  /// Update Authorization header for all future requests
  ///
  void _updateAuthorizationHeader(String token) {
    dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> get(
      String uri, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      await ensureInitialized();
      final response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      await ensureInitialized();
      final response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }
}