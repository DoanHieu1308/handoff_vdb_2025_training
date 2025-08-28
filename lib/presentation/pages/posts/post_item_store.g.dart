// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostItemStore on _PostItemStore, Store {
  late final _$hashtagsAtom =
      Atom(name: '_PostItemStore.hashtags', context: context);

  @override
  ObservableList<String> get hashtags {
    _$hashtagsAtom.reportRead();
    return super.hashtags;
  }

  @override
  set hashtags(ObservableList<String> value) {
    _$hashtagsAtom.reportWrite(value, super.hashtags, () {
      super.hashtags = value;
    });
  }

  late final _$commentParentIdAtom =
      Atom(name: '_PostItemStore.commentParentId', context: context);

  @override
  String get commentParentId {
    _$commentParentIdAtom.reportRead();
    return super.commentParentId;
  }

  @override
  set commentParentId(String value) {
    _$commentParentIdAtom.reportWrite(value, super.commentParentId, () {
      super.commentParentId = value;
    });
  }

  late final _$commentUserNameAtom =
      Atom(name: '_PostItemStore.commentUserName', context: context);

  @override
  String get commentUserName {
    _$commentUserNameAtom.reportRead();
    return super.commentUserName;
  }

  @override
  set commentUserName(String value) {
    _$commentUserNameAtom.reportWrite(value, super.commentUserName, () {
      super.commentUserName = value;
    });
  }

  late final _$hasTextCommentAtom =
      Atom(name: '_PostItemStore.hasTextComment', context: context);

  @override
  bool get hasTextComment {
    _$hasTextCommentAtom.reportRead();
    return super.hasTextComment;
  }

  @override
  set hasTextComment(bool value) {
    _$hasTextCommentAtom.reportWrite(value, super.hasTextComment, () {
      super.hasTextComment = value;
    });
  }

  late final _$commentListAtom =
      Atom(name: '_PostItemStore.commentList', context: context);

  @override
  ObservableList<PostCommentModel> get commentList {
    _$commentListAtom.reportRead();
    return super.commentList;
  }

  @override
  set commentList(ObservableList<PostCommentModel> value) {
    _$commentListAtom.reportWrite(value, super.commentList, () {
      super.commentList = value;
    });
  }

  late final _$currentCommentPageAtom =
      Atom(name: '_PostItemStore.currentCommentPage', context: context);

  @override
  int get currentCommentPage {
    _$currentCommentPageAtom.reportRead();
    return super.currentCommentPage;
  }

  @override
  set currentCommentPage(int value) {
    _$currentCommentPageAtom.reportWrite(value, super.currentCommentPage, () {
      super.currentCommentPage = value;
    });
  }

  late final _$hasMoreCommentsAtom =
      Atom(name: '_PostItemStore.hasMoreComments', context: context);

  @override
  bool get hasMoreComments {
    _$hasMoreCommentsAtom.reportRead();
    return super.hasMoreComments;
  }

  @override
  set hasMoreComments(bool value) {
    _$hasMoreCommentsAtom.reportWrite(value, super.hasMoreComments, () {
      super.hasMoreComments = value;
    });
  }

  late final _$isShowBottomSheetAtom =
      Atom(name: '_PostItemStore.isShowBottomSheet', context: context);

  @override
  bool get isShowBottomSheet {
    _$isShowBottomSheetAtom.reportRead();
    return super.isShowBottomSheet;
  }

  @override
  set isShowBottomSheet(bool value) {
    _$isShowBottomSheetAtom.reportWrite(value, super.isShowBottomSheet, () {
      super.isShowBottomSheet = value;
    });
  }

  late final _$_PostItemStoreActionController =
      ActionController(name: '_PostItemStore', context: context);

  @override
  void initMentionListener({bool force = false}) {
    final _$actionInfo = _$_PostItemStoreActionController.startAction(
        name: '_PostItemStore.initMentionListener');
    try {
      return super.initMentionListener(force: force);
    } finally {
      _$_PostItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateReactionInPostsList(
      {required String postId,
      required String selectedReaction,
      required ObservableList<PostOutputModel> postsList}) {
    final _$actionInfo = _$_PostItemStoreActionController.startAction(
        name: '_PostItemStore.updateReactionInPostsList');
    try {
      return super.updateReactionInPostsList(
          postId: postId,
          selectedReaction: selectedReaction,
          postsList: postsList);
    } finally {
      _$_PostItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hashtags: ${hashtags},
commentParentId: ${commentParentId},
commentUserName: ${commentUserName},
hasTextComment: ${hasTextComment},
commentList: ${commentList},
currentCommentPage: ${currentCommentPage},
hasMoreComments: ${hasMoreComments},
isShowBottomSheet: ${isShowBottomSheet}
    ''';
  }
}
