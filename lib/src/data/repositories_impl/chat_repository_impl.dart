import 'dart:async';
import 'package:chat/src/core/services/firebase_auth_service.dart';
import 'package:chat/src/data/datasources/local/chat_message_local.dart';
import 'package:chat/src/data/models/chat_message_models.dart';
import 'package:chat/src/domain/entities/chat_message_entity.dart';
import 'package:chat/src/domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_message_remote.dart';

class ChatRepositoryImpl implements ChatRepository{
  final ChatMessageLocal _local;
  final ChatMessageRemote _remote;
  StreamSubscription<ChatMessageModel>? _sub;
  ChatRepositoryImpl(this._local, this._remote);

  @override
  Future<ChatMessageEntity?> sendMessage(String roomId, ChatMessageModel messageModel) async {
    final uploaded = await _remote.sendMessage(messageModel, roomId);
    if (uploaded == null) return null;
    print('[ChatRepositoryImpl] Message sent successfully');
    final entity = uploaded.toEntity();
    return entity;
  }

  @override
  List<ChatMessageEntity> getLocalMessages() {
    return _local.getListMessages();
  }

  @override
  Future<void> saveNewMessageToLocal() async {
    print('[ChatRepositoryImpl] Bắt đầu đồng bộ.....');

    // 1. Lấy timestamp mới nhất trong local
    int latestTimestamp = _local.getLatestLocalTimestamp(_local.chatMessageBox);
    print("[ChatRepositoryImpl] Timestamp mới nhất: $latestTimestamp");

    // 2. Lấy roomId -> cần await
    String? roomId = await _remote.getCurrentRoom(
      FirebaseAuthService().getCurrentUser()!.uid,
    );

    // 3. Nếu roomId null thì dừng
    if (roomId == null) {
      print("[ChatRepositoryImpl] ❌ Không tìm thấy roomId!");
      return;
    }

    // 4. Lấy tin nhắn mới từ server
    List<ChatMessageModel> newMessages =
    await _remote.getNewMessages(roomId, latestTimestamp);
    print("[ChatRepositoryImpl] Số lượng tin nhắn mới: ${newMessages.length}");

    // 5. Lưu từng tin nhắn vào local
    for (ChatMessageModel message in newMessages) {
      ChatMessageEntity entity = message.toEntity();
      _local.saveMessage(entity);
      print('[ChatRepositoryImpl] Saved message to local: ${entity.messageId}');
    }
  }

  @override
  Stream<ChatMessageModel> listenAndSaveMessages(String roomId) {
    return _remote.messagesStreamChildAdded(roomId).map((msg) {
      _local.saveMessage(msg.toEntity());
      return msg;
    });
  }

  @override
  Stream<bool> isInRoomStream(String roomId) {
    return _remote.isInRoomStream(roomId);
  }



  @override
  Future<bool> endChat() async {
    final callAPIEnd = await _remote.endChat();
    if(callAPIEnd){
      _local.removeAllMessages();
      return true;
    }
    return false;
  }

  @override
  void endChatByStranger() {
    _local.removeAllMessages();
  }

  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }
}