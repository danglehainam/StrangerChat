import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../../data/models/chat_message_models.dart';

class ChatRepository {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');

  // Gửi tin nhắn
  Future<void> sendMessage(ChatMessage message) async {
    print('[ChatRepository] Sending message: ${message.toJson()}');
    try {
      final newRef = _messagesRef.push();
      print('[ChatRepository] New message ref key: ${newRef.key}');
      await newRef.set(message.toJson());
      print('[ChatRepository] Message sent successfully');
    } catch (error) {
      print('[ChatRepository] Error in sendMessage: $error');
      rethrow;
    }
  }

  // Lắng nghe messages theo thứ tự timestamp
  Stream<List<ChatMessage>> messagesStream({int limit = 50}) {
    print('[ChatRepository] Setting up messages stream with limit $limit');
    final query = _messagesRef.orderByChild('timestamp').limitToLast(limit);

    return query.onValue.map((event) {
      print('[ChatRepository] onValue triggered');

      final snap = event.snapshot;
      if (!snap.exists) {
        print('[ChatRepository] No messages found (snapshot empty)');
        return <ChatMessage>[];
      }

      final map = snap.value as Map<dynamic, dynamic>?;
      if (map == null) {
        print('[ChatRepository] No messages found (map null)');
        return <ChatMessage>[]; // Ép kiểu ở đây nữa
      }

      print('[ChatRepository] Raw messages from DB: $map');

      final list = <ChatMessage>[];
      map.forEach((key, value) {
        print('[ChatRepository] Parsing message with key: $key, value: $value');
        final m = ChatMessage.fromSnapshot(key as String, value as Map);
        list.add(m);
      });

      list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      print('[ChatRepository] Parsed and sorted ${list.length} messages');

      return list; // Dart sẽ hiểu đây là List<ChatMessage>
    }).handleError((error) {
      print('[ChatRepository] Error in messagesStream: $error');
    });
  }
}
