import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class FirebaseMatchService {
  final db = FirebaseDatabase.instance;

  StreamSubscription<DatabaseEvent> listenForRoom(String uid, Function(String?) onRoomFound) {
    final ref = db.ref("users/$uid/currentRoom");
    return ref.onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null && val is String) {
        onRoomFound(val);
      }
    });
  }
}
