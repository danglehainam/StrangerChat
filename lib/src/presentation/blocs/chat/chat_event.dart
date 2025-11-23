import 'package:chat/src/domain/entities/chat_message_entity.dart';

import '../../../data/models/chat_message_models.dart';

abstract class ChatEvent {}
class ChatInit extends ChatEvent{}
class StartListening extends ChatEvent {
  final String roomId;
  StartListening(this.roomId);
}
class StopListening extends ChatEvent {}
class SendMessageEvent extends ChatEvent {
  final ChatMessageModel message;
  final String roomId;
  SendMessageEvent(this.message, this.roomId);
}
class MessagesUpdated extends ChatEvent {
  final List<ChatMessageEntity> messages;
  MessagesUpdated(this.messages);
}
class EndChatEvent extends ChatEvent {
  final bool isInRoom;
  EndChatEvent(this.isInRoom);
}

