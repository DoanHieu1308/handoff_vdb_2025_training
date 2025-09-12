import 'package:chatview/chatview.dart' as cv;
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/enums/message_content_type.dart';
import '../response/user_model.dart';
import 'package:chatview/chatview.dart' as cv;
import 'package:chatview/chatview.dart';

class ChatMessageModel {
  final String? id;
  final String? senderId;
  final String? senderName;
  final String? senderAvatar;
  final String? content;
  final MessageContentType? type;
  final CustomMessageSubType? customSubType;
  final Map<String, List<UserModel>>? reactions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isEdited;
  final MessageStatus? status;
  final ChatMessageModel? replyMessage;

  final String? mediaUrl;
  final String? mediaThumbnail;
  final Duration? mediaDuration;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;

  final String? localId;

  final Map<String, dynamic>? additionalData;

  ChatMessageModel({
    this.id,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.content,
    this.type,
    this.customSubType,
    this.reactions,
    this.createdAt,
    this.updatedAt,
    this.isEdited,
    this.status,
    this.replyMessage,
    this.mediaUrl,
    this.mediaThumbnail,
    this.mediaDuration,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.localId,
    this.additionalData,
  });

  cv.Message toChatViewMessage() {
    return cv.Message(
      id: id ?? "",
      message: content ?? "",
      createdAt: createdAt ?? DateTime.now(),
      sentBy: senderId ?? "",
      replyMessage: replyMessage != null
          ? cv.ReplyMessage(
        message: replyMessage?.content ?? "",
        replyTo: replyMessage?.senderName ?? "",
        messageType: _mapType(replyMessage?.type),
      )
          : const cv.ReplyMessage(),
      messageType: _mapType(type),
      status: _mapStatus(),
      reaction: _buildReaction(),
      voiceMessageDuration: type == MessageContentType.voice
          ? mediaDuration
          : null,
    );
  }

  cv.MessageType _mapType(MessageContentType? type) {
    switch (type) {
      case MessageContentType.text:
        return cv.MessageType.text;
      case MessageContentType.image:
        return cv.MessageType.image;
      case MessageContentType.voice:
        return cv.MessageType.voice;
      case MessageContentType.audio:
      case MessageContentType.video:
      case MessageContentType.custom:
        return cv.MessageType.custom;
      default:
        return cv.MessageType.text;
    }
  }

  cv.MessageStatus _mapStatus() {
    switch (status) {
      case MessageStatus.read:
        return cv.MessageStatus.read;
      case MessageStatus.delivered:
        return cv.MessageStatus.delivered;
      case MessageStatus.undelivered:
        return cv.MessageStatus.undelivered;
      case MessageStatus.pending:
        return cv.MessageStatus.pending;
      default:
        return cv.MessageStatus.pending;
    }
  }

  cv.Reaction _buildReaction() {
    if (reactions != null && reactions!.isNotEmpty) {
      return cv.Reaction(
        reactions: reactions!.keys.toList(),
        reactedUserIds: reactions!.values
            .expand((users) => users.map((u) => u.id ?? ""))
            .toList(),
      );
    }
    return cv.Reaction(reactions: [], reactedUserIds: []);
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'type': type?.name,
      'reactions': reactions?.map(
            (k, v) => MapEntry(k, v.map((user) => user.toMap()).toList()),
      ),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isEdited': isEdited,
      'status': status?.name,
      'replyMessage': replyMessage?.toMap(),
      'mediaUrl': mediaUrl,
      'mediaThumbnail': mediaThumbnail,
      'mediaDuration': mediaDuration?.inMilliseconds,
      'fileName': fileName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'localId': localId,
      'additionalData': {
        if (customSubType != null) 'subType': customSubType!.name,
        ...?additionalData,
      },
    };
    return map;
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    final additional = map['additionalData'] != null
        ? Map<String, dynamic>.from(map['additionalData'])
        : null;

    return ChatMessageModel(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      senderAvatar: map['senderAvatar'],
      content: map['content'],
      type: MessageContentType.tryParse(map['type']),
      customSubType: CustomMessageSubType.tryParse(additional?['subType']),
      reactions: (map['reactions'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
          k,
          (v as List<dynamic>)
              .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
              .toList(),
        ),
      ),
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : (map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null),
      updatedAt: (map['updatedAt'] is Timestamp)
          ? (map['updatedAt'] as Timestamp).toDate()
          : (map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null),
      isEdited: map['isEdited'],
      status: map['status'] != null
          ? MessageStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => MessageStatus.pending,
      )
          : MessageStatus.pending,
      replyMessage: map['replyMessage'] != null
          ? ChatMessageModel.fromMap(
        Map<String, dynamic>.from(map['replyMessage']),
      )
          : null,
      mediaUrl: map['mediaUrl'],
      mediaThumbnail: map['mediaThumbnail'],
      mediaDuration: map['mediaDuration'] != null
          ? Duration(milliseconds: map['mediaDuration'])
          : null,
      fileName: map['fileName'],
      fileSize: map['fileSize'],
      mimeType: map['mimeType'],
      localId: map['localId'],
      additionalData: additional,
    );
  }
}


