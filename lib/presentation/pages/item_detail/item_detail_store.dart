import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

part 'item_detail_store.g.dart';

class ItemDetailStore = _ItemDetailStore with _$ItemDetailStore;

abstract class _ItemDetailStore with Store {
  /// Controller
  final AutoScrollController scrollController = AutoScrollController(axis: Axis.vertical);


}