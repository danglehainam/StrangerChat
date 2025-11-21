import 'package:chat/src/data/models/chat_message_models.dart';
import 'package:chat/src/domain/entities/chat_message_entity.dart';

abstract class ChatRepository{
  Future<ChatMessageEntity?> sendMessage(String roomId, ChatMessageModel message);
  List<ChatMessageEntity> getLocalMessages();
  Future<void> saveNewMessageToLocal();
  Stream<ChatMessageModel> listenAndSaveMessages(String roomId);
  Stream<bool> isInRoom(String roomId);
  Future<void> endChat();
  void endChatByStranger();
}