import 'package:firebase_database/firebase_database.dart';

class FirebasePresenceService {
  /// Thiết lập trạng thái online/offline cho user hiện tại
  void setupUserPresence(String userId) {
    final db = FirebaseDatabase.instance;
    final statusRef = db.ref('status/$userId');
    final connectedRef = db.ref('.info/connected');

    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;

      if (connected) {
        final onlineStatus = {
          'userId' : userId,
          'state': 'online',
          'last_changed': ServerValue.timestamp,
        };

        final offlineStatus = {
          'userId' : userId,
          'state': 'offline',
          'last_changed': ServerValue.timestamp,
        };

        // Khi client disconnect, Firebase sẽ tự động set offline
        statusRef.onDisconnect().set(offlineStatus);

        // Khi kết nối, set ngay online
        statusRef.set(onlineStatus);
      }
    });
  }

  Future<void> setUserOffline(String userId) async {
    final db = FirebaseDatabase.instance;
    final statusRef = db.ref('status/$userId');

    await statusRef.set({
      'userId': userId,
      'state': 'offline',
      'last_changed': ServerValue.timestamp,
    });
  }

  /// Lắng nghe trạng thái online/offline của một user
  Stream<String> listenToUserPresence(String userId) {
    final statusRef = FirebaseDatabase.instance.ref('status/$userId');
    return statusRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return 'offline';
      print(data['state']);
      return data['state']?.toString() ?? 'offline';
    });
  }
}
