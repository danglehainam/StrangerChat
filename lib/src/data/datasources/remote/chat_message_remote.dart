import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../models/chat_message_models.dart';

class ChatMessageRemote {
  final baseUrl = dotenv.env['API_BASE_URL'];
  final find = dotenv.env['FIND_ROOM'];
  final leave = dotenv.env['LEAVE_QUEUE'];
  final end = dotenv.env['END_ROOM'];
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref();
  StreamSubscription? _messagesSub;


  DatabaseReference pushMessage(String roomId) {
    return _messagesRef.child('rooms').child(roomId).child('messages').push();
  }

  Future<String?> getToken()async{
    return await FirebaseAuth.instance.currentUser!.getIdToken();
  }

  Future<List<ChatMessageModel>> getNewMessages(String roomId, int afterTimestamp) async {
    final ref = _messagesRef
        .child("rooms/$roomId/messages")
        .orderByChild("timestamp")
        .startAfter(afterTimestamp);

    final snap = await ref.get();
    if (!snap.exists) return [];

    final map = snap.value as Map;
    final list = map.entries.map((e) {
      return ChatMessageModel.fromSnapshot(e.key, e.value);
    }).toList();

    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }


  //Gửi tin nhắn lên RTDB, trả về đối tượng
  Future<ChatMessageModel?> sendMessage(ChatMessageModel message, String roomId) async {
    print('[ChatRemote] Sending message: ${message.toJson()}');
    try {
      final newRef = pushMessage(roomId);
      print('[ChatRemote] New message ref key: ${newRef.key}');
      await newRef.set(message.toJson());
      print('[ChatRemote] Message sent successfully');
      message.id = newRef.key!;
      final messageWithId = message;
      return messageWithId;
    } catch (error) {
      print('[ChatRemote] Error in sendMessage: $error');
      return null;
    }
  }

  Stream<bool> isInRoom(String roomId){
    final ref = _messagesRef.child('rooms').child(roomId);
    return ref.onValue.map((event) {
      return event.snapshot.value != null;
    });
  }

  Stream<ChatMessageModel> messagesStreamChildAdded(String roomId) {
    print('[ChatRemote] Setting up incremental messages stream');
    final ref = _messagesRef.child('rooms').child(roomId).child('messages');
    return ref
        .orderByChild('timestamp')
        .onChildAdded
        .map((event) {
      print('[ChatRemote] New message received with key: ${event.snapshot.key}');
      final snap = event.snapshot;
      final msg = ChatMessageModel.fromSnapshot(
        snap.key!,
        snap.value as Map<dynamic, dynamic>,
      );
      return msg;
    })
        .handleError((error) {
      print('[ChatRemote] Error in messagesStream: $error');
    });
  }

  Future<Map<String, dynamic>> findMatch() async {
    final token = await getToken();
    print('[ChatRemote] Token: $token');
    print('[ChatRemote] Making POST request to $baseUrl$find');
    final res = await http.post(
      Uri.parse("$baseUrl$find"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print('[ChatRemote] Response status code: ${res.statusCode}');
    print('[ChatRemote] Response body: ${res.body}');
    return json.decode(res.body);
  }

  Future<String?> getCurrentRoom(String uid) async {
    try {
      final snapshot = await FirebaseDatabase.instance
          .ref('users/$uid/currentRoom')
          .get()
          .timeout(const Duration(seconds: 5));

      if (snapshot.value == null) return null;

      return snapshot.value as String;
    } on TimeoutException {
      print('Timeout khi lấy currentRoom (mất mạng)');
      return 'TIMEOUT';
    } catch (e) {
      print('Lỗi khác khi lấy currentRoom: $e');
      return null;
    }
  }




  Future<void> leaveQueue() async {
    final token = await getToken();
    await http.post(
      Uri.parse("$baseUrl$leave"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }

  Future<bool> endChat()async{
    try{
      final token = await getToken();
      await http.post(
        Uri.parse("$baseUrl$end"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print('[ChatRemote] Call API end chat successfully');
      return true;
    }catch(e){
      print('[ChatRemote] Error in endChat: $e');
      return false;
    }

  }

  Future<void> dispose()async {
    _messagesSub?.cancel();
  }
}
