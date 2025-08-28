import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'conversation_store.g.dart';

class ConversationStore = _ConversationStore with _$ConversationStore;

abstract class _ConversationStore with Store {
  /// Value
  @observable
  int currentIndex = 0;

  @action
  void onChangedDashboardPage({required int index}){
    if (index == currentIndex) return;
    currentIndex = index;
  }
}