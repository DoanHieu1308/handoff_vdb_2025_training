import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersParLine = 200;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('REQUEST[${options.method}] => DATA: ${options.data}');
    print('REQUEST[${options.method}] => HEADERS: ${options.headers}');
    
    // Skip refresh token request to avoid infinite loop
    if (options.path.contains('/auth/refresh-token')) {
      return super.onRequest(options, handler);
    }
    
    super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler ) async {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}');
    print('ERROR[${err.response?.statusCode}] => DATA: ${err.response?.data}');
    
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      
      // Add current request to pending list
      _pendingRequests.add(err.requestOptions);
      
      try {
        final sharedPreferenceHelper = SharedPreferenceHelper.instance;
        final refreshToken = sharedPreferenceHelper.getRefreshToken;
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          // Create a new Dio instance for refresh token request
          final refreshDio = Dio();
          refreshDio.options.baseUrl = EndPoint.BASE_URL;
          refreshDio.options.headers = {
            'Content-Type': 'application/json; charset=UTF-8',
          };
          
          final response = await refreshDio.post(
            EndPoint.REFRESH_TOKEN,
            data: {'refreshToken': refreshToken},
          );
          
          if (response.statusCode == 200) {
            final results = response.data as dynamic;
            final metadatas = results['metadata'] as Map<String, dynamic>;
            final tokens = metadatas['tokens'] != null ? metadatas['tokens'] as Map<String, dynamic> : null;
            
            final newAccessToken = tokens?['accessToken'].toString();
            if (newAccessToken != null) {
              await sharedPreferenceHelper.setAccessToken(newAccessToken);
              
              // Update the original Dio instance headers
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              
              // Retry all pending requests with new token
              for (final request in _pendingRequests) {
                try {
                  request.headers['Authorization'] = 'Bearer $newAccessToken';
                  final retryResponse = await refreshDio.fetch(request);
                  print('Retry request successful: ${request.path}');
                } catch (retryError) {
                  print('Retry request failed: ${request.path} - $retryError');
                }
              }
              
              _pendingRequests.clear();
              _isRefreshing = false;
              
              // Retry the original request
              final retryResponse = await refreshDio.fetch(err.requestOptions);
              return handler.resolve(retryResponse);
            }
          }
        }
      } catch (e) {
        print('Token refresh failed: $e');
        // Clear auth data if refresh fails
        final sharedPreferenceHelper = SharedPreferenceHelper.instance;
        await sharedPreferenceHelper.clearAuthData();
        
        // Clear pending requests
        _pendingRequests.clear();
      }
      
      _isRefreshing = false;
    }
    
    return handler.next(err);
  }
}