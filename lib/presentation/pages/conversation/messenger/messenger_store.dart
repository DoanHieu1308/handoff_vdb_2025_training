import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/services/firebase_presence_service.dart';
import 'package:mobx/mobx.dart';

import '../conversation_store.dart';

part 'messenger_store.g.dart';

class MessengerStore = _MessengerStore with _$MessengerStore;

abstract class _MessengerStore with Store {
  /// Controller
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchMessController = TextEditingController();

  /// Firebase
  final FirebasePresenceService firebasePresenceService = AppInit.instance.firebasePresenceService;

  /// Store
  final ConversationStore conversationStore;
  _MessengerStore(this.conversationStore);

  /// Focus Nodes
  final FocusNode searchFocusNode = FocusNode();

  /// Shared Preference Helper
  final SharedPreferenceHelper sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Text
  @observable
  bool isHasInput = false;
}