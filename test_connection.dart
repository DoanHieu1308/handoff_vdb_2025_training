import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  dio.options.baseUrl = "http://192.168.100.64:5000/v1/api";
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  
  try {
    print('Testing connection to: ${dio.options.baseUrl}/auth/register');
    final response = await dio.get('/auth/register');
    print('Connection successful! Status: ${response.statusCode}');
    print('Response: ${response.data}');
  } catch (e) {
    print('Connection failed: $e');
    if (e is DioError) {
      print('DioError type: ${e.type}');
      print('DioError message: ${e.message}');
      print('DioError response: ${e.response?.statusCode}');
    }
  }
} 