import 'dart:io';

import 'package:mobx/mobx.dart';

part 'post_status_store.g.dart';

class PostStatusStore = _PostStatusStore with _$PostStatusStore;

abstract class _PostStatusStore with Store {
  @observable
  ObservableList<File> listFile = ObservableList.of([
    // File('/data/user/0/com.example.handoff_vdb_2025/cache/media_1753866534447.jpg'),
    // File('/data/user/0/com.example.handoff_vdb_2025/cache/media_1753866630585.jpg'),
    File('/data/user/0/com.example.handoff_vdb_2025/cache/031144f2-a59c-4662-8dff-3af6e7c23393/0df07796950e6f0a04cd0586e0679924.mp4')
  ]);
}
