import 'package:chat/src/domain/entities/chat_message_entity.dart';

import '../../../data/models/chat_message_models.dart';

abstract class MessagesEvent {}
class StartListening extends MessagesEvent {
  final String roomId;
  StartListening(this.roomId);
}
class StopListening extends MessagesEvent {}
class SendMessageEvent extends MessagesEvent {
  final ChatMessageModel message;
  final String roomId;
  SendMessageEvent(this.message, this.roomId);
}
class MessagesUpdated extends MessagesEvent {
  final List<ChatMessageEntity> messages;
  MessagesUpdated(this.messages);
}
class EndChatEvent extends MessagesEvent {
  final bool isInRoom;
  EndChatEvent(this.isInRoom);
}

