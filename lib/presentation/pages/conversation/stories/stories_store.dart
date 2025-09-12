import 'package:mobx/mobx.dart';

import '../conversation_store.dart';

part 'stories_store.g.dart';

class StoriesStore = _StoriesStore with _$StoriesStore;

abstract class _StoriesStore with Store {
  /// Store
  final ConversationStore conversationStore;
  _StoriesStore(this.conversationStore);

}