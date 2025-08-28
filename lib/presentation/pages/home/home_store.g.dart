// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$isLoadingPostAtom =
      Atom(name: '_HomeStore.isLoadingPost', context: context);

  @override
  bool get isLoadingPost {
    _$isLoadingPostAtom.reportRead();
    return super.isLoadingPost;
  }

  @override
  set isLoadingPost(bool value) {
    _$isLoadingPostAtom.reportWrite(value, super.isLoadingPost, () {
      super.isLoadingPost = value;
    });
  }

  late final _$allPostsPublicAtom =
      Atom(name: '_HomeStore.allPostsPublic', context: context);

  @override
  ObservableList<PostOutputModel> get allPostsPublic {
    _$allPostsPublicAtom.reportRead();
    return super.allPostsPublic;
  }

  @override
  set allPostsPublic(ObservableList<PostOutputModel> value) {
    _$allPostsPublicAtom.reportWrite(value, super.allPostsPublic, () {
      super.allPostsPublic = value;
    });
  }

  late final _$allPostsFriendAtom =
      Atom(name: '_HomeStore.allPostsFriend', context: context);

  @override
  ObservableList<PostOutputModel> get allPostsFriend {
    _$allPostsFriendAtom.reportRead();
    return super.allPostsFriend;
  }

  @override
  set allPostsFriend(ObservableList<PostOutputModel> value) {
    _$allPostsFriendAtom.reportWrite(value, super.allPostsFriend, () {
      super.allPostsFriend = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_HomeStore.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$hasMoreAtom = Atom(name: '_HomeStore.hasMore', context: context);

  @override
  bool get hasMore {
    _$hasMoreAtom.reportRead();
    return super.hasMore;
  }

  @override
  set hasMore(bool value) {
    _$hasMoreAtom.reportWrite(value, super.hasMore, () {
      super.hasMore = value;
    });
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  void clearPostMessage() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.clearPostMessage');
    try {
      return super.clearPostMessage();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<String> getTop2Reactions(PostOutputModel postData) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.getTop2Reactions');
    try {
      return super.getTop2Reactions(postData);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  int getTotalFeelCount(Map<String, dynamic>? feelCount) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.getTotalFeelCount');
    try {
      return super.getTotalFeelCount(feelCount);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingPost: ${isLoadingPost},
allPostsPublic: ${allPostsPublic},
allPostsFriend: ${allPostsFriend},
currentPage: ${currentPage},
hasMore: ${hasMore}
    ''';
  }
}
