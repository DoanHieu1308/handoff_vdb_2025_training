import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/data/model/chat_bot/chat_bot_message_model.dart';

import '../../core/init/app_init.dart';
import '../../core/shared_pref/shared_preference_helper.dart';
import '../../domain/end_points/end_point.dart';
import '../data_source/dio/dio_client.dart';
import '../exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class ChatBotRepository {
  final DioClient _dio = AppInit.instance.dioClient;
  late SharedPreferenceHelper _sharedPreferenceHelper;

  ChatBotRepository() {
    _init();
  }

  Future<void> _init() async {
    _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  }

  /// Get bot response
  Future<void> getBotResponse({
    required String question,
    required void Function(ChatBotMessage data) onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    print("acces: $accessToken");

    try {
      final response = await _dio.post(
        "http://192.168.100.64:8000/chatbot/ask",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          "question" : question,
        }
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final results = response.data as Map<String, dynamic>;
        final answer = results['answer'] as String;
        final loadingMessage = ChatBotMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: question,
          botResponse: answer,
          timestamp: DateTime.now(),
          isFromUser: false,
          isLoading: true,
        );

        onSuccess(loadingMessage);
      } else {
        final message = ApiErrorHandler.getMessage(response.data);
        onError(ApiResponse.withError(message).error);
      }
    } catch (e) {
      print("Get Posts Error: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
    }
  }

}