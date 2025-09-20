class ChatBotMessage {
  final String id;
  final String content;
  final String? botResponse;
  final DateTime timestamp;
  final bool isFromUser;
  final bool isLoading;

  ChatBotMessage({
    required this.id,
    required this.content,
    this.botResponse,
    required this.timestamp,
    required this.isFromUser,
    this.isLoading = false,
  });

  ChatBotMessage copyWith({
    String? id,
    String? content,
    String? botResponse,
    DateTime? timestamp,
    bool? isFromUser,
    bool? isLoading,
  }) {
    return ChatBotMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      botResponse: botResponse ?? this.botResponse,
      timestamp: timestamp ?? this.timestamp,
      isFromUser: isFromUser ?? this.isFromUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'botResponse': botResponse,
      'timestamp': timestamp.toIso8601String(),
      'isFromUser': isFromUser,
      'isLoading': isLoading,
    };
  }

  factory ChatBotMessage.fromJson(Map<String, dynamic> json) {
    return ChatBotMessage(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      botResponse: json['botResponse'],
      timestamp: DateTime.parse(json['timestamp']),
      isFromUser: json['isFromUser'] ?? false,
      isLoading: json['isLoading'] ?? false,
    );
  }
}
