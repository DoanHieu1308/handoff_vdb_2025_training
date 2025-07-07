import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'dash_board_store.g.dart';

class DashBoardStore = _DashBoardStore with _$DashBoardStore;

abstract class _DashBoardStore with Store {
  @observable
  int currentIndex = 1;

  @action
  void onChangedDashboardPage({required int index}){
    if (index == currentIndex) return;
    currentIndex = index;
  }
}