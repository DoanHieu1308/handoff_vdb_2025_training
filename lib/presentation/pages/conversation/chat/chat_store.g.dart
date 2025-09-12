// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  late final _$showAutoscrollAtom =
      Atom(name: '_ChatStore.showAutoscroll', context: context);

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

  late final _$replyMessageAtom =
      Atom(name: '_ChatStore.replyMessage', context: context);

  @override
  ChatMessageModel? get replyMessage {
    _$replyMessageAtom.reportRead();
    return super.replyMessage;
  }

  @override
  set replyMessage(ChatMessageModel? value) {
    _$replyMessageAtom.reportWrite(value, super.replyMessage, () {
      super.replyMessage = value;
    });
  }

  late final _$isHasInputAtom =
      Atom(name: '_ChatStore.isHasInput', context: context);

  @override
  bool get isHasInput {
    _$isHasInputAtom.reportRead();
    return super.isHasInput;
  }

  @override
  set isHasInput(bool value) {
    _$isHasInputAtom.reportWrite(value, super.isHasInput, () {
      super.isHasInput = value;
    });
  }

  late final _$entitiesAtom =
      Atom(name: '_ChatStore.entities', context: context);

  @override
  ObservableList<AssetEntity> get entities {
    _$entitiesAtom.reportRead();
    return super.entities;
  }

  @override
  set entities(ObservableList<AssetEntity> value) {
    _$entitiesAtom.reportWrite(value, super.entities, () {
      super.entities = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ChatStore.isLoading', context: context);

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

  late final _$isLoadingMoreAtom =
      Atom(name: '_ChatStore.isLoadingMore', context: context);

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportRead();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.reportWrite(value, super.isLoadingMore, () {
      super.isLoadingMore = value;
    });
  }

  late final _$hasMoreToLoadAtom =
      Atom(name: '_ChatStore.hasMoreToLoad', context: context);

  @override
  bool get hasMoreToLoad {
    _$hasMoreToLoadAtom.reportRead();
    return super.hasMoreToLoad;
  }

  @override
  set hasMoreToLoad(bool value) {
    _$hasMoreToLoadAtom.reportWrite(value, super.hasMoreToLoad, () {
      super.hasMoreToLoad = value;
    });
  }

  late final _$pathAtom = Atom(name: '_ChatStore.path', context: context);

  @override
  AssetPathEntity? get path {
    _$pathAtom.reportRead();
    return super.path;
  }

  @override
  set path(AssetPathEntity? value) {
    _$pathAtom.reportWrite(value, super.path, () {
      super.path = value;
    });
  }

  late final _$listFileAtom =
      Atom(name: '_ChatStore.listFile', context: context);

  @override
  ObservableList<dynamic> get listFile {
    _$listFileAtom.reportRead();
    return super.listFile;
  }

  @override
  set listFile(ObservableList<dynamic> value) {
    _$listFileAtom.reportWrite(value, super.listFile, () {
      super.listFile = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ChatStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$conversationIdAtom =
      Atom(name: '_ChatStore.conversationId', context: context);

  @override
  String get conversationId {
    _$conversationIdAtom.reportRead();
    return super.conversationId;
  }

  @override
  set conversationId(String value) {
    _$conversationIdAtom.reportWrite(value, super.conversationId, () {
      super.conversationId = value;
    });
  }

  late final _$messagesAtom =
      Atom(name: '_ChatStore.messages', context: context);

  @override
  List<ChatMessageModel>? get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(List<ChatMessageModel>? value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$showItemActionAtom =
      Atom(name: '_ChatStore.showItemAction', context: context);

  @override
  String get showItemAction {
    _$showItemActionAtom.reportRead();
    return super.showItemAction;
  }

  @override
  set showItemAction(String value) {
    _$showItemActionAtom.reportWrite(value, super.showItemAction, () {
      super.showItemAction = value;
    });
  }

  late final _$listItemActionChat1Atom =
      Atom(name: '_ChatStore.listItemActionChat1', context: context);

  @override
  List<Map<String, dynamic>> get listItemActionChat1 {
    _$listItemActionChat1Atom.reportRead();
    return super.listItemActionChat1;
  }

  @override
  set listItemActionChat1(List<Map<String, dynamic>> value) {
    _$listItemActionChat1Atom.reportWrite(value, super.listItemActionChat1, () {
      super.listItemActionChat1 = value;
    });
  }

  late final _$listItemActionChat2Atom =
      Atom(name: '_ChatStore.listItemActionChat2', context: context);

  @override
  List<Map<String, dynamic>> get listItemActionChat2 {
    _$listItemActionChat2Atom.reportRead();
    return super.listItemActionChat2;
  }

  @override
  set listItemActionChat2(List<Map<String, dynamic>> value) {
    _$listItemActionChat2Atom.reportWrite(value, super.listItemActionChat2, () {
      super.listItemActionChat2 = value;
    });
  }

  late final _$initializeChatAsyncAction =
      AsyncAction('_ChatStore.initializeChat', context: context);

  @override
  Future<void> initializeChat(List<UserModel> friends) {
    return _$initializeChatAsyncAction.run(() => super.initializeChat(friends));
  }

  late final _$listenHasInputAsyncAction =
      AsyncAction('_ChatStore.listenHasInput', context: context);

  @override
  Future<void> listenHasInput() {
    return _$listenHasInputAsyncAction.run(() => super.listenHasInput());
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('_ChatStore.sendMessage', context: context);

  @override
  Future<String?> sendMessage(
      {required String content,
      required MessageContentType type,
      ChatMessageModel? replyMessage,
      CustomMessageSubType? subType,
      String? localId,
      String? mediaUrl,
      String? mediaThumbnail,
      Duration? mediaDuration,
      String? fileName,
      int? fileSize,
      String? mimeType,
      Map<String, dynamic>? additionalData}) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(
        content: content,
        type: type,
        replyMessage: replyMessage,
        subType: subType,
        localId: localId,
        mediaUrl: mediaUrl,
        mediaThumbnail: mediaThumbnail,
        mediaDuration: mediaDuration,
        fileName: fileName,
        fileSize: fileSize,
        mimeType: mimeType,
        additionalData: additionalData));
  }

  late final _$requestMediaAsyncAction =
      AsyncAction('_ChatStore.requestMedia', context: context);

  @override
  Future<void> requestMedia() {
    return _$requestMediaAsyncAction.run(() => super.requestMedia());
  }

  late final _$loadMoreMediasAsyncAction =
      AsyncAction('_ChatStore.loadMoreMedias', context: context);

  @override
  Future<void> loadMoreMedias() {
    return _$loadMoreMediasAsyncAction.run(() => super.loadMoreMedias());
  }

  late final _$deleteMessageAsyncAction =
      AsyncAction('_ChatStore.deleteMessage', context: context);

  @override
  Future<void> deleteMessage(String messageId) {
    return _$deleteMessageAsyncAction.run(() => super.deleteMessage(messageId));
  }

  late final _$sendTypingIndicatorAsyncAction =
      AsyncAction('_ChatStore.sendTypingIndicator', context: context);

  @override
  Future<void> sendTypingIndicator(bool isTyping) {
    return _$sendTypingIndicatorAsyncAction
        .run(() => super.sendTypingIndicator(isTyping));
  }

  late final _$_ChatStoreActionController =
      ActionController(name: '_ChatStore', context: context);

  @override
  Stream<List<Message>> searchMessages(String query) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.searchMessages');
    try {
      return super.searchMessages(query);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showAutoscroll: ${showAutoscroll},
replyMessage: ${replyMessage},
isHasInput: ${isHasInput},
entities: ${entities},
isLoading: ${isLoading},
isLoadingMore: ${isLoadingMore},
hasMoreToLoad: ${hasMoreToLoad},
path: ${path},
listFile: ${listFile},
errorMessage: ${errorMessage},
conversationId: ${conversationId},
messages: ${messages},
showItemAction: ${showItemAction},
listItemActionChat1: ${listItemActionChat1},
listItemActionChat2: ${listItemActionChat2}
    ''';
  }
}
