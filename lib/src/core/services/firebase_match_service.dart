import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class FirebaseMatchService {
  final db = FirebaseDatabase.instance;

  StreamSubscription<DatabaseEvent> listenForRoom(String uid, Function(String?) onRoomFound) {
    final infoRef = db.ref().child("users").child(uid);

    // Lấy thông tin toàn bộ node một lần để in ra
    infoRef.get().then((snapshot) {
      final val = snapshot.value;
      print('Full node for users/$uid: $val');
    });
    final ref = db.ref()
        .child("users")
        .child(uid)
        .child("currentRoom");
    print('FirebaseMatchService.listenForRoom(): users/$uid/currentRoom');
    ref.get().then((snapshot){
      final roomId = snapshot.value;
      print('FirebaseMatchService.listenForRoom(): $roomId');
    });
    return ref.onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null && val is String) {
        onRoomFound(val);
        print('FirebaseMatchService.listenForRoom(): $val');
      }
    });
  }
}
