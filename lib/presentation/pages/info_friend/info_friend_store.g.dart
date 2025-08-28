// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_friend_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InfoFriendStore on _InfoFriendStore, Store {
  late final _$profileFriendAtom =
      Atom(name: '_InfoFriendStore.profileFriend', context: context);

  @override
  FriendProfileModel get profileFriend {
    _$profileFriendAtom.reportRead();
    return super.profileFriend;
  }

  @override
  set profileFriend(FriendProfileModel value) {
    _$profileFriendAtom.reportWrite(value, super.profileFriend, () {
      super.profileFriend = value;
    });
  }

  late final _$selectedFolderIndexAtom =
      Atom(name: '_InfoFriendStore.selectedFolderIndex', context: context);

  @override
  int get selectedFolderIndex {
    _$selectedFolderIndexAtom.reportRead();
    return super.selectedFolderIndex;
  }

  @override
  set selectedFolderIndex(int value) {
    _$selectedFolderIndexAtom.reportWrite(value, super.selectedFolderIndex, () {
      super.selectedFolderIndex = value;
    });
  }

  late final _$isLSeeMoreAtom =
      Atom(name: '_InfoFriendStore.isLSeeMore', context: context);

  @override
  bool get isLSeeMore {
    _$isLSeeMoreAtom.reportRead();
    return super.isLSeeMore;
  }

  @override
  set isLSeeMore(bool value) {
    _$isLSeeMoreAtom.reportWrite(value, super.isLSeeMore, () {
      super.isLSeeMore = value;
    });
  }

  late final _$postsAtom =
      Atom(name: '_InfoFriendStore.posts', context: context);

  @override
  ObservableList<PostOutputModel> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(ObservableList<PostOutputModel> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: '_InfoFriendStore.currentPage', context: context);

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

  late final _$hasMoreAtom =
      Atom(name: '_InfoFriendStore.hasMore', context: context);

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

  late final _$_InfoFriendStoreActionController =
      ActionController(name: '_InfoFriendStore', context: context);

  @override
  void onChangedFolderIndexProfile({required int index}) {
    final _$actionInfo = _$_InfoFriendStoreActionController.startAction(
        name: '_InfoFriendStore.onChangedFolderIndexProfile');
    try {
      return super.onChangedFolderIndexProfile(index: index);
    } finally {
      _$_InfoFriendStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profileFriend: ${profileFriend},
selectedFolderIndex: ${selectedFolderIndex},
isLSeeMore: ${isLSeeMore},
posts: ${posts},
currentPage: ${currentPage},
hasMore: ${hasMore}
    ''';
  }
}
