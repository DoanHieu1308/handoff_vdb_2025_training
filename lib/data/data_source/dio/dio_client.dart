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
  
  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  DioClient(){
    _init();
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
  /// Init dio
  ///
  Future<void> _init() async {
    dio = Dio();

    final token = _sharedPreferenceHelper.getAccessToken;
    print("Dio access____: $token");

    dio!
      ..options.baseUrl = EndPoint.BASE_URL
      ..options.connectTimeout = const Duration(seconds: 15) // Reduced from 60s
      ..options.receiveTimeout = const Duration(seconds: 20) // Reduced from 60s
      ..options.sendTimeout = const Duration(seconds: 15) // Added send timeout
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      };

    // Add interceptors
    dio!.interceptors.add(LoggingInterceptor());
    cookieJar = CookieJar();
    dio!.interceptors.add(CookieManager(cookieJar));

    // Auto refresh token when 401
    dio!.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          print("Access token expired, refreshing...");

          final success = await refreshTokens();
          if (success) {
            final newToken = _sharedPreferenceHelper.getAccessToken;

            // Update header for all requests
            dio!.options.headers['Authorization'] = 'Bearer $newToken';

            // Retry the original request
            final requestOptions = e.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';
            
            try {
              final cloneReq = await dio!.fetch(requestOptions);
              return handler.resolve(cloneReq);
            } catch (retryError) {
              return handler.next(e);
            }
          }
        }
        return handler.next(e);
      },
    ));

    _isInitialized = true;
  }

  ///
  /// Refresh token
  ///
  Future<bool> refreshTokens() async {
    final String? refreshToken = _sharedPreferenceHelper.getRefreshToken;

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await cookieJar.saveFromResponse(
        Uri.parse(EndPoint.BASE_URL),
        [Cookie('refreshToken', refreshToken)],
      );

      try {
        final response = await dio!.post(
          EndPoint.REFRESH_TOKEN,
          options: Options(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

        if (response.statusCode == 200) {
          final results = response.data as dynamic;
          final metadatas = results['metadata'] as Map<String, dynamic>;
          final tokens = metadatas['tokens'] != null
              ? metadatas['tokens'] as Map<String, dynamic>
              : null;

          final newAccessToken = tokens?['accessToken']?.toString();
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await _sharedPreferenceHelper.setAccessToken(newAccessToken);

            await cookieJar.saveFromResponse(
              Uri.parse(EndPoint.BASE_URL),
              [Cookie('accessToken', newAccessToken)],
            );

            print("New accessToken updated: $newAccessToken");
            return true;
          }
        }
      } catch (e) {
        print('Token refresh failed: $e');
        await _sharedPreferenceHelper.clearAuthData();
      }
    }
    return false;
  }

  ///
  /// Retry mechanism for failed requests
  ///
  Future<Response> _retryRequest(
    Future<Response> Function() request,
    int retryCount,
  ) async {
    try {
      return await request();
    } catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        await Future.delayed(_retryDelay * (retryCount + 1));
        return _retryRequest(request, retryCount + 1);
      }
      rethrow;
    }
  }

  ///
  /// Check if error is retryable
  ///
  bool _shouldRetry(dynamic error) {
    if (error is DioException) {
      // Retry on network errors, 5xx server errors, but not on 4xx client errors
      return error.type == DioExceptionType.connectionTimeout ||
             error.type == DioExceptionType.receiveTimeout ||
             error.type == DioExceptionType.sendTimeout ||
             error.type == DioExceptionType.connectionError ||
             (error.response?.statusCode != null && 
              error.response!.statusCode! >= 500);
    }
    return false;
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
      
      return await _retryRequest(() async {
        return await dio!.get(
          uri,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      }, 0);
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
      
      return await _retryRequest(() async {
        return await dio!.post(
          uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      }, 0);
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
      await ensureInitialized();
      
      return await _retryRequest(() async {
        return await dio!.put(
          uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      }, 0);
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(
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
      
      return await _retryRequest(() async {
        return await dio!.patch(
          uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      }, 0);
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
      await ensureInitialized();
      
      return await _retryRequest(() async {
        return await dio!.delete(
          uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
      }, 0);
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  ///
  /// Dispose resources
  ///
  void dispose() {
    try {
      dio?.close();
      cookieJar.deleteAll();
    } catch (e) {
      print('Error disposing Dio client: $e');
    }
  }
}