import 'package:chat/src/domain/entities/chat_message_entity.dart';

abstract class MessagesState {}
class MessagesInitial extends MessagesState {}
class MessagesLoadInProgress extends MessagesState {}
class MessagesLoadSuccess extends MessagesState {
  final List<ChatMessageEntity> messages;
  MessagesLoadSuccess(this.messages);
}
class MessagesFailure extends MessagesState {
  final String error;
  MessagesFailure(this.error);
}
class EndChatState extends MessagesState{
  final String message;
  EndChatState(this.message);
}