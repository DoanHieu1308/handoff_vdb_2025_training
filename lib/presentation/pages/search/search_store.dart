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
  Future<void> init() async {
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