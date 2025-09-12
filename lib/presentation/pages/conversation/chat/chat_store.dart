import 'dart:async';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/enums/message_content_type.dart';
import 'package:handoff_vdb_2025/data/model/chat/chat_message_model.dart';
import 'package:intl/intl.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';
import 'package:mobx/mobx.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/conversation_store.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/utils/images_path.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  /// Store
   ConversationStore conversationStore;

  _ChatStore(this.conversationStore);

  final ProfileStore profileStore = AppInit.instance.profileStore;

  /// Controller
  final ScrollController chatScrollController = ScrollController();
   final ScrollController imageScrollController = ScrollController();
  final TextEditingController writeMessController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  /// Focus
  final FocusNode chatFocusNode = FocusNode();

  /// Firebase
  final firebaseChatService = AppInit.instance.firebaseChatService;
  final firebasePresenceService = AppInit.instance.firebasePresenceService;

  /// Chat
  @observable
  bool showAutoscroll = false;
  @observable
  ChatMessageModel? replyMessage;
  @observable
  bool isHasInput = false;
  VoidCallback? textListener;

   /// Media
   final int sizePerPage = 50;
   @observable
   ObservableList<AssetEntity> entities = ObservableList<AssetEntity>();
   @observable
   bool isLoading = false;
   @observable
   bool isLoadingMore = false;
   @observable
   bool hasMoreToLoad = true;
   @observable
   AssetPathEntity? path;
   int _page = 0;
   int _totalEntitiesCount = 0;
   /// file
   @observable
   ObservableList<dynamic> listFile = ObservableList.of([]);
   ObservableList<String> selectedIds = ObservableList<String>();

  /// Value
  @observable
  String? errorMessage;
  @observable
  String conversationId = "";
  @observable
  List<ChatMessageModel>? messages;
  @observable
  String showItemAction = "";

  /// List item detail all
  @observable
  List<Map<String, dynamic>> listItemActionChat1 =
      List.of([
        {'name': "Location", 'image': ImagesPath.icLocationChat, 'valueNumber': 0},
        {'name': "Games", 'image': ImagesPath.icGamesChat, 'valueNumber': 1},
        {'name': "Reminders", 'image': ImagesPath.icRemindersChat, 'valueNumber': 2},
        {'name': "GIFs", 'image': ImagesPath.icGifsChat, 'valueNumber': 3},
      ]);

  @observable
  List<Map<String, dynamic>> listItemActionChat2 =
  List.of([
    {'name': "Apple Music", 'image': ImagesPath.icAppleMusicChat, 'valueNumber': 0},
    {'name': "Swelly", 'image': ImagesPath.icSwellyChat, 'valueNumber': 1},
    {'name': "Pinterest", 'image': ImagesPath.icPinterestChat, 'valueNumber': 2},
    {'name': "Gfycat", 'image': ImagesPath.icGfycatChat, 'valueNumber': 3},
    {'name': "Tenor GIF Keyboard B...", 'image': ImagesPath.icTenorGifChat, 'valueNumber': 4},
  ]);

  /// Initialize chat with friend, setup realtime listeners
  @action
  Future<void> initializeChat(List<UserModel> friends) async {
    try {
      final me = profileStore.userProfile;
      if(me.name == null) return;
      messages?.clear();
      conversationId = await firebaseChatService.createOrGetConversation(
        me,
        friends
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {}
  }

  /// Listen has input
  @action
  Future<void> listenHasInput() async {
    if (textListener != null) {
      writeMessController.removeListener(textListener!);
    }

    textListener = () {
      final text = writeMessController.text;
      isHasInput = text.isNotEmpty;
    };
    writeMessController.addListener(textListener!);
  }

   /// Send a message
   @action
   Future<String?> sendMessage({
     required String content,
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
     Map<String, dynamic>? additionalData,
   }) async {
     if (conversationId == null) return null;

     try {
       final id = await firebaseChatService.sendMessage(
         conversationId: conversationId,
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
         additionalData: additionalData,
       );
       return id;
     } catch (e) {
       errorMessage = "Không thể gửi tin nhắn: $e";
       return null;
     }
   }


   String? formatLastMessageTime(DateTime current, DateTime? last, {DateTime? prev}) {
     if (last == null) return null;

     if (prev != null) {
       final diffMinutes = last.difference(prev).inMinutes.abs();
       if (diffMinutes < 10) {
         return null;
       }
     }

     if (last.year == current.year &&
         last.month == current.month &&
         last.day == current.day) {
       return DateFormat('HH:mm').format(last);
     }

     DateTime startOfWeek = current.subtract(Duration(days: current.weekday - 1));
     DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
     if (last.isAfter(startOfWeek) && last.isBefore(endOfWeek)) {
       final weekdayNames = {
         1: "Thứ 2",
         2: "Thứ 3",
         3: "Thứ 4",
         4: "Thứ 5",
         5: "Thứ 6",
         6: "Thứ 7",
         7: "Chủ nhật",
       };
       return "${weekdayNames[last.weekday]}, lúc ${DateFormat('HH:mm').format(last)}";
     }

     if (last.year == current.year) {
       return "${DateFormat('dd/MM').format(last)}, lúc ${DateFormat('HH:mm').format(last)}";
     }

     return "${DateFormat('dd/MM/yyyy').format(last)}, lúc ${DateFormat('HH:mm').format(last)}";
   }

   /// Get media in Gallery
   @action
   Future<void> requestMedia() async {
     isLoading = true;
     final PermissionState ps = await PhotoManager.requestPermissionExtend();

     if (!ps.hasAccess) {
       isLoading = false;
       return;
     }

     final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
       onlyAll: true,
       filterOption: FilterOptionGroup(
         imageOption: const FilterOption(
           sizeConstraint: SizeConstraint(ignoreSize: true),
         ),
       ),
     );

     if (paths.isEmpty) {
       isLoading = false;
       return;
     }

     path = paths.first;
     _totalEntitiesCount = await path!.assetCountAsync;
     final List<AssetEntity> firstPage = await path!.getAssetListPaged(
       page: 0,
       size: sizePerPage,
     );

     entities = ObservableList.of(firstPage);
     hasMoreToLoad = entities.length < _totalEntitiesCount;
     isLoading = false;
     _page = 0;
   }

   /// Load more media in Gallery
   @action
   Future<void> loadMoreMedias() async {
     if (isLoadingMore || !hasMoreToLoad || path == null) return;

     isLoadingMore = true;
     final List<AssetEntity> more = await path!.getAssetListPaged(
       page: _page + 1,
       size: sizePerPage,
     );

     entities.addAll(more);
     _page++;
     hasMoreToLoad = entities.length < _totalEntitiesCount;
     isLoadingMore = false;
   }

   /// Delete a message
  @action
  Future<void> deleteMessage(String messageId) async {
    if (conversationId == null) return;
    try {
      await firebaseChatService.deleteMessage(
        conversationId: conversationId,
        messageId: messageId,
      );
    } catch (e) {
      errorMessage = "Không thể xoá tin nhắn: $e";
    }
  }

  /// Send typing indicator
  @action
  Future<void> sendTypingIndicator(bool isTyping) async {
    if (conversationId == null) return;
    try {
      await firebaseChatService.sendTypingIndicator(
        conversationId: conversationId,
        isTyping: isTyping,
      );
    } catch (_) {}
  }

  /// Search messages realtime
  @action
  Stream<List<Message>> searchMessages(String query) {
    if (conversationId == null) return const Stream.empty();
    try {
      return firebaseChatService.searchMessagesRealtime(
        conversationId: conversationId!,
        query: query,
      );
    } catch (e) {
      errorMessage = 'Không thể tìm kiếm: $e';
      return const Stream.empty();
    }
  }

  /// Scroll chat to bottom
  void scrollToBottom() {
    if (!chatScrollController.hasClients) return;
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
    );
  }

  /// Dispose all controllers and subscriptions
  void disposeAll() {
    chatScrollController.dispose();
    imageScrollController.dispose();
    writeMessController.dispose();
    searchController.dispose();
  }
}
