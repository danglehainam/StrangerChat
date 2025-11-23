import 'package:chat/src/domain/entities/chat_message_entity.dart';

abstract class ChatState {}
class MessagesInitial extends ChatState {}
class MessagesLoadInProgress extends ChatState {}
class MessagesLoadSuccess extends ChatState {
  final List<ChatMessageEntity> messages;
  MessagesLoadSuccess(this.messages);
}
class MessagesFailure extends ChatState {
  final String error;
  MessagesFailure(this.error);
}
class EndChatState extends ChatState{
  final String message;
  EndChatState(this.message);
}