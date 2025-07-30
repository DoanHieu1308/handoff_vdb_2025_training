import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/logging_interceptor.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';
import '../../../core/shared_pref/shared_preference_helper.dart';

class DioClient {
  final SharedPreferenceHelper _sharedPreferenceHelper = SharedPreferenceHelper.instance;
  late final Dio? dio;
  late final CookieJar cookieJar;
  bool _isInitialized = false;

  DioClient(){
    _init();
  }

  ///
 /// Init dio
 ///
 // Future<void> _init() async {
 //    dio = Dio();
 //
 //    dio!
 //      ..options.baseUrl = EndPoint.BASE_URL
 //      ..options.connectTimeout = const Duration(seconds: 60)
 //      ..options.receiveTimeout = const Duration(seconds: 60)
 //      ..httpClientAdapter
 //      ..options.headers = {
 //        'Content-Type': 'application/json; charset=UTF-8',
 //      };
 //    dio!.interceptors.add(LoggingInterceptor());
 //    cookieJar = CookieJar();
 //    dio!.interceptors.add(CookieManager(cookieJar));
 //
 //    // If accessToken exists, set it as cookie
 //    final token = _sharedPreferenceHelper.getAccessToken;
 //    print("Dio access____: $token");
 //
 //    if (token != null && token.isNotEmpty) {
 //      await cookieJar.saveFromResponse(
 //        Uri.parse(EndPoint.BASE_URL),
 //        [Cookie('accessToken', token)],
 //      );
 //    }
 //
 //    _isInitialized = true;
 // }
  Future<void> _init() async {
    dio = Dio();

    final token = _sharedPreferenceHelper.getAccessToken;
    print("Dio access____: $token");

    dio!
      ..options.baseUrl = EndPoint.BASE_URL
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      };

    dio!.interceptors.add(LoggingInterceptor());

    // Nếu bạn vẫn muốn dùng CookieJar cho mục đích khác thì giữ lại
    cookieJar = CookieJar();
    dio!.interceptors.add(CookieManager(cookieJar));

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
  Future<void> refreshTokens() async {
    final String? refreshToken = _sharedPreferenceHelper.getRefreshToken;

    if (refreshToken != null && refreshToken.isNotEmpty) {
      // Set refreshToken in cookie
      await cookieJar.saveFromResponse(
        Uri.parse(EndPoint.BASE_URL),
        [Cookie('refreshToken', refreshToken)],
      );

      try {
        final response = await dio!.post(EndPoint.REFRESH_TOKEN);
        
        if (response.statusCode == 200) {
          final results = response.data as dynamic;

          final metadatas = results['metadata'] as Map<String, dynamic>;
          final tokens = metadatas['tokens']  != null ? metadatas['tokens'] as Map<String, dynamic> : null;

          final newAccessToken = tokens?['accessToken'].toString();
          if (newAccessToken != null) {
            await _sharedPreferenceHelper.setAccessToken(newAccessToken);

            // Update accessToken cookie
            await cookieJar.saveFromResponse(
              Uri.parse(EndPoint.BASE_URL),
              [Cookie('accessToken', newAccessToken)],
            );

            print("New accessToken updated: $newAccessToken");
          }
        }
      } catch (e) {
        print('Token refresh failed: $e');
        // If refresh fails, clear all auth data
        await _sharedPreferenceHelper.clearAuthData();
      }
    }
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