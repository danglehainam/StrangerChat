import '../../../data/models/chat_message_models.dart';

abstract class MessagesState {}
class MessagesInitial extends MessagesState {}
class MessagesLoadInProgress extends MessagesState {}
class MessagesLoadSuccess extends MessagesState {
  final List<ChatMessage> messages;
  MessagesLoadSuccess(this.messages);
}
class MessagesFailure extends MessagesState {
  final String error;
  MessagesFailure(this.error);
}