import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  /// Controller
  final ScrollController scrollController = ScrollController();
  final TextEditingController writeMessController = TextEditingController();

  /// Focus Nodes
  final FocusNode chatFocusNode = FocusNode();

  /// Chat
  @observable
  bool showAutoscroll = false;
  @observable
  bool isAssistantFromHistory = false;
  @observable
  bool isHasInput = false;

  ///------------------------------------------------------------
  /// Dispose
  ///
  void disposeAll() {
  }

  final List<Message> messages = [
    Message(
      id: "1",
      text: "Xin chào",
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      id: "2",
      text: "Bạn khỏe không?",
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    Message(
      id: "3",
      text: "Mình khỏe",
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Message(
      id: "4",
      text: "Còn bạn?",
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Message(
      id: "5",
      text: "Mình cũng khỏe",
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];


  ///
  /// Scroll to the end
  ///
  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
}
