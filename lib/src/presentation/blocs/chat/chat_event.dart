import '../../../data/models/chat_message_models.dart';

abstract class MessagesEvent {}
class StartListening extends MessagesEvent {}
class StopListening extends MessagesEvent {}
class SendMessageEvent extends MessagesEvent {
  final ChatMessage message;
  SendMessageEvent(this.message);
}
class MessagesUpdated extends MessagesEvent {
  final List<ChatMessage> messages;
  MessagesUpdated(this.messages);
}
