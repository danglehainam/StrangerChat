import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/models/chat_message_models.dart';
import '../../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepository repo;
  StreamSubscription<List<ChatMessage>>? _sub;

  MessagesBloc({required this.repo}) : super(MessagesInitial()) {
    on<StartListening>((event, emit) async {
      print('[MessagesBloc] StartListening event received');
      emit(MessagesLoadInProgress());
      print('[MessagesBloc] Emitted MessagesLoadInProgress state');

      _sub ??= repo.messagesStream().listen(
            (messages) {
          print('[MessagesBloc] New messages received from stream: ${messages.length}');
          print('[MessagesBloc] Messages: $messages');
          add(MessagesUpdated(messages));
        },
        onError: (e) {
          print('[MessagesBloc] Error in messagesStream: $e');
          addError(e);
        },
      );

      print('[MessagesBloc] Subscribed to messages stream');
    });

    on<MessagesUpdated>((event, emit) {
      print('[MessagesBloc] MessagesUpdated event received with ${event.messages.length} messages');
      emit(MessagesLoadSuccess(event.messages));
      print('[MessagesBloc] Emitted MessagesLoadSuccess state with messages');
    });

    on<SendMessageEvent>((event, emit) async {
      print('[MessagesBloc] SendMessageEvent received with message: ${event.message}');
      try {
        await repo.sendMessage(event.message);
        print('[MessagesBloc] Message sent successfully');
      } catch (e) {
        print('[MessagesBloc] Error sending message: $e');
        emit(MessagesFailure(e.toString()));
      }
    });

    on<StopListening>((event, emit) async {
      print('[MessagesBloc] StopListening event received');
      await _sub?.cancel();
      print('[MessagesBloc] Stream subscription canceled');
      _sub = null;
    });
  }

  @override
  Future<void> close() {
    print('[MessagesBloc] close called, canceling subscription if exists');
    _sub?.cancel();
    return super.close();
  }
}
