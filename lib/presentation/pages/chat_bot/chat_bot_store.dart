import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/repositories/chat_bot_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:handoff_vdb_2025/data/model/chat_bot/chat_bot_message_model.dart';
import 'dart:async';

part 'chat_bot_store.g.dart';

class ChatBotStore = _ChatBotStore with _$ChatBotStore;

abstract class _ChatBotStore with Store {
  /// Controller
  final ScrollController chatBotScrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  /// Repository
  final ChatBotRepository _chatBotRepository = AppInit.instance.chatBotRepository;

  /// Observable state
  @observable
  ObservableList<ChatBotMessage> messages = ObservableList<ChatBotMessage>();

  @observable
  bool showAutoscroll = false;

  @observable
  bool isAssistantFromHistory = false;

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @observable
  List<String> suggestedQuestions = [];

  @observable
  bool showSuggestions = true;

  /// Suggested questions database
  final List<String> _commonQuestions = [
    'Xin chào',
    'Tôi muốn tìm kiếm bạn bè thì làm thế nào',
    'Làm thế nào để tạo bài viết mới?',
    'Tôi muốn chat với bạn bè thì vào đâu?',
    'Tôi có thể đổi ảnh đại diện không?',
    'Cảm ơn bạn!',
    'Tạm biệt!',
  ];

  /// Actions
  @action
  void addMessage(String content) {
    final message = ChatBotMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isFromUser: true,
    );
    messages.add(message);
    
    // Hide suggestions when user sends message
    showSuggestions = false;
    
    // Generate bot response
    _generateBotResponse(message);
    
    // Scroll to bottom
    _scrollToBottom();
  }

  @action
  Future<void> _generateBotResponse(ChatBotMessage userMessage) async {
    // Add loading message
    final loadingMessage = ChatBotMessage(
      id: '${userMessage.id}_loading',
      content: '',
      timestamp: DateTime.now(),
      isFromUser: false,
      isLoading: true,
    );
    messages.add(loadingMessage);
    _scrollToBottom();

    try {
      await _chatBotRepository.getBotResponse(
        question: userMessage.content,
        onSuccess: (botMessage) {
          // Remove loading message
          messages.removeWhere((msg) => msg.id == loadingMessage.id);
          
          // Add bot response
          final responseMessage = ChatBotMessage(
            id: '${userMessage.id}_response',
            content: '',
            botResponse: botMessage.botResponse,
            timestamp: DateTime.now(),
            isFromUser: false,
            isLoading: false,
          );
          messages.add(responseMessage);
          _scrollToBottom();
        },
        onError: (error) {
          // Remove loading message
          messages.removeWhere((msg) => msg.id == loadingMessage.id);
          
          // Add error message
          final errorMessage = ChatBotMessage(
            id: '${userMessage.id}_error',
            content: '',
            botResponse: 'Xin lỗi, tôi không thể trả lời câu hỏi này lúc này. Vui lòng thử lại sau.',
            timestamp: DateTime.now(),
            isFromUser: false,
            isLoading: false,
          );
          messages.add(errorMessage);
          _scrollToBottom();
          
          setError(error.toString());
        }
      );
    } catch (e) {
      // Remove loading message
      messages.removeWhere((msg) => msg.id == loadingMessage.id);
      
      // Add error message
      final errorMessage = ChatBotMessage(
        id: '${userMessage.id}_error',
        content: '',
        botResponse: 'Xin lỗi, đã xảy ra lỗi. Vui lòng thử lại sau.',
        timestamp: DateTime.now(),
        isFromUser: false,
        isLoading: false,
      );
      messages.add(errorMessage);
      _scrollToBottom();
      
      setError(e.toString());
    }
  }


  @action
  void _scrollToBottom() {
    if (chatBotScrollController.hasClients) {
      chatBotScrollController.animateTo(
        chatBotScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @action
  void scrollToBottom() {
    _scrollToBottom();
  }

  @action
  void clearMessages() {
    messages.clear();
    isAssistantFromHistory = false;
    showSuggestions = true;
    updateSuggestions('');
  }

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @action
  void setError(String error) {
    errorMessage = error;
  }

  @action
  void clearError() {
    errorMessage = '';
  }

  @action
  void retryLastMessage() {
    if (messages.isNotEmpty) {
      final lastUserMessage = messages.lastWhere(
        (msg) => msg.isFromUser,
        orElse: () => messages.first,
      );
      if (lastUserMessage.isFromUser) {
        _generateBotResponse(lastUserMessage);
      }
    }
  }

  @action
  void deleteMessage(String messageId) {
    messages.removeWhere((msg) => msg.id == messageId);
  }

  @action
  void setAssistantFromHistory(bool value) {
    isAssistantFromHistory = value;
  }

  @action
  void updateSuggestions(String input) {
    if (input.isEmpty) {
      // Show random suggestions when input is empty
      suggestedQuestions = _getRandomSuggestions(5);
    } else {
      // Filter suggestions based on input
      suggestedQuestions = _commonQuestions
          .where((question) => 
              question.toLowerCase().contains(input.toLowerCase()) ||
              input.toLowerCase().contains(question.toLowerCase()))
          .take(5)
          .toList();
      
      // If no matches found, show random suggestions
      if (suggestedQuestions.isEmpty) {
        suggestedQuestions = _getRandomSuggestions(3);
      }
    }
  }

  List<String> _getRandomSuggestions(int count) {
    final shuffled = List<String>.from(_commonQuestions)..shuffle();
    return shuffled.take(count).toList();
  }

  @action
  void selectSuggestion(String suggestion) {
    addMessage(suggestion);
  }

  @action
  void showSuggestionsPanel() {
    showSuggestions = true;
    updateSuggestions('');
  }

  @action
  void hideSuggestionsPanel() {
    showSuggestions = false;
  }

  void dispose() {
    chatBotScrollController.dispose();
    messageController.dispose();
  }
}