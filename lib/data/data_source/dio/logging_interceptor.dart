import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';


class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersParLine = 200;
  bool _isRefreshing = false;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('REQUEST[${options.method}] => DATA: ${options.data}');
    print('REQUEST[${options.method}] => HEADERS: ${options.headers}');
    super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler ) async {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}');
    print('ERROR[${err.response?.statusCode}] => DATA: ${err.response?.data}');
    
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      
      try {
        // Initialize SharedPreferences
        final sharedPreferenceHelper = SharedPreferenceHelper.instance;
        
        final refreshToken = sharedPreferenceHelper.getRefreshToken;
        if (refreshToken != null && refreshToken.isNotEmpty) {
          // Try to refresh token
          final dio = Dio();
          dio.options.baseUrl = "http://192.168.100.64:5000/v1/api";
          
          final response = await dio.post(
            '/auth/refresh-token',
            data: {'refreshToken': refreshToken},
          );
          
          if (response.statusCode == 200) {
            final newAccessToken = response.data['accessToken'];
            await sharedPreferenceHelper.setAccessToken(newAccessToken);
            
            // Retry the original request with new token
            final originalRequest = err.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
            
            final retryResponse = await dio.fetch(originalRequest);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        print('Token refresh failed: $e');
        // Clear auth data if refresh fails
        final sharedPreferenceHelper = SharedPreferenceHelper.instance;
        await sharedPreferenceHelper.clearAuthData();
      }
      
      _isRefreshing = false;
    }
    
    return handler.next(err);
  }
}