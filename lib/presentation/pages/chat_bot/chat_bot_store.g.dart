// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_bot_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatBotStore on _ChatBotStore, Store {
  late final _$messagesAtom =
      Atom(name: '_ChatBotStore.messages', context: context);

  @override
  ObservableList<ChatBotMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<ChatBotMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$showAutoscrollAtom =
      Atom(name: '_ChatBotStore.showAutoscroll', context: context);

  @override
  bool get showAutoscroll {
    _$showAutoscrollAtom.reportRead();
    return super.showAutoscroll;
  }

  @override
  set showAutoscroll(bool value) {
    _$showAutoscrollAtom.reportWrite(value, super.showAutoscroll, () {
      super.showAutoscroll = value;
    });
  }

  late final _$isAssistantFromHistoryAtom =
      Atom(name: '_ChatBotStore.isAssistantFromHistory', context: context);

  @override
  bool get isAssistantFromHistory {
    _$isAssistantFromHistoryAtom.reportRead();
    return super.isAssistantFromHistory;
  }

  @override
  set isAssistantFromHistory(bool value) {
    _$isAssistantFromHistoryAtom
        .reportWrite(value, super.isAssistantFromHistory, () {
      super.isAssistantFromHistory = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ChatBotStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ChatBotStore.errorMessage', context: context);

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$suggestedQuestionsAtom =
      Atom(name: '_ChatBotStore.suggestedQuestions', context: context);

  @override
  List<String> get suggestedQuestions {
    _$suggestedQuestionsAtom.reportRead();
    return super.suggestedQuestions;
  }

  @override
  set suggestedQuestions(List<String> value) {
    _$suggestedQuestionsAtom.reportWrite(value, super.suggestedQuestions, () {
      super.suggestedQuestions = value;
    });
  }

  late final _$showSuggestionsAtom =
      Atom(name: '_ChatBotStore.showSuggestions', context: context);

  @override
  bool get showSuggestions {
    _$showSuggestionsAtom.reportRead();
    return super.showSuggestions;
  }

  @override
  set showSuggestions(bool value) {
    _$showSuggestionsAtom.reportWrite(value, super.showSuggestions, () {
      super.showSuggestions = value;
    });
  }

  late final _$_generateBotResponseAsyncAction =
      AsyncAction('_ChatBotStore._generateBotResponse', context: context);

  @override
  Future<void> _generateBotResponse(ChatBotMessage userMessage) {
    return _$_generateBotResponseAsyncAction
        .run(() => super._generateBotResponse(userMessage));
  }

  late final _$_ChatBotStoreActionController =
      ActionController(name: '_ChatBotStore', context: context);

  @override
  void addMessage(String content) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.addMessage');
    try {
      return super.addMessage(content);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _scrollToBottom() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore._scrollToBottom');
    try {
      return super._scrollToBottom();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void scrollToBottom() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.scrollToBottom');
    try {
      return super.scrollToBottom();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearMessages() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.clearMessages');
    try {
      return super.clearMessages();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String error) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.setError');
    try {
      return super.setError(error);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void retryLastMessage() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.retryLastMessage');
    try {
      return super.retryLastMessage();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteMessage(String messageId) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.deleteMessage');
    try {
      return super.deleteMessage(messageId);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAssistantFromHistory(bool value) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.setAssistantFromHistory');
    try {
      return super.setAssistantFromHistory(value);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSuggestions(String input) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.updateSuggestions');
    try {
      return super.updateSuggestions(input);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectSuggestion(String suggestion) {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.selectSuggestion');
    try {
      return super.selectSuggestion(suggestion);
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showSuggestionsPanel() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.showSuggestionsPanel');
    try {
      return super.showSuggestionsPanel();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hideSuggestionsPanel() {
    final _$actionInfo = _$_ChatBotStoreActionController.startAction(
        name: '_ChatBotStore.hideSuggestionsPanel');
    try {
      return super.hideSuggestionsPanel();
    } finally {
      _$_ChatBotStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
showAutoscroll: ${showAutoscroll},
isAssistantFromHistory: ${isAssistantFromHistory},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
suggestedQuestions: ${suggestedQuestions},
showSuggestions: ${showSuggestions}
    ''';
  }
}
