import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'messenger_store.g.dart';

class MessengerStore = _MessengerStore with _$MessengerStore;

abstract class _MessengerStore with Store {
  /// Controller
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchMessController = TextEditingController();

  /// Focus Nodes
  final FocusNode searchFocusNode = FocusNode();

  /// Text
  @observable
  bool isHasInput = false;
}