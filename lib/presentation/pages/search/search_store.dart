import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'search_store.g.dart';


class SearchStore = _SearchStore with _$SearchStore;

abstract class _SearchStore with Store {
  /// Controllers
  final TextEditingController textEditingController = TextEditingController();

  ///
  @observable
  String searchText = '';
  @observable
  bool hasText = false;

  ///
  /// Init
  ///
  _SearchStore() {
    _init();
  }

  Future<void> _init() async {
    // Thêm listener để cập nhật searchText khi text thay đổi
    textEditingController.addListener(() {
      searchText = textEditingController.text;
      hasText = searchText.isNotEmpty;
    });
  }

  ///
  /// Dispose
  ///
  void disposeAll() {
  }

}