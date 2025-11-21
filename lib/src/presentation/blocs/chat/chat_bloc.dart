import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/models/chat_message_models.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepositoryImpl repo;
  StreamSubscription<ChatMessageModel>? _subMessage;
  StreamSubscription<bool>? _subInRoom;


  MessagesBloc({required this.repo}) : super(MessagesInitial()) {
    on<MessageInit>((event, emit) {
      emit(MessagesLoadInProgress());
    });

    on<StartListening>((event, emit) async {
      print('[MessagesBloc] StartListening event received');
      emit(MessagesLoadInProgress());
      final localMessages = repo.getLocalMessages();
      print('[MessagesBloc] Local messages: $localMessages');
      emit(MessagesLoadSuccess(localMessages));
      print('[MessagesBloc] Syncing new messages to local...');
      await repo.saveNewMessageToLocal();
      print('[MessagesBloc] Sync done.');
      _subMessage ??= repo.listenAndSaveMessages(event.roomId).listen(
            (msg) {
          add(MessagesUpdated([msg.toEntity()]));
        },
        onError: (e) => addError(e),
      );
      print('[MessagesBloc] Subscribed to messages stream');
      _subInRoom ??= repo.isInRoom(event.roomId).listen((isInRoom) {
          add(EndChatEvent(isInRoom));
        },
        onError: (e) => addError(e),
      );
    });
    print('[MessagesBloc] Subscribed to is in room stream');

    on<EndChatEvent>((event, emit) {
      if (!event.isInRoom) {
        emit(EndChatState('Đã kết thúc cuộc trò chuyện'));
      }
    });

    on<MessagesUpdated>((event, emit) {
      final current = (state is MessagesLoadSuccess)
          ? (state as MessagesLoadSuccess).messages
          : [];
      emit(MessagesLoadSuccess([...current, ...event.messages]));
    });


    on<SendMessageEvent>((event, emit) async {
      print('[MessagesBloc] SendMessageEvent received with message: ${event.message}');
      try {
        await repo.sendMessage(event.roomId, event.message);
        print('[MessagesBloc] Message sent successfully');
      } catch (e) {
        print('[MessagesBloc] Error sending message: $e');
        emit(MessagesFailure(e.toString()));
      }
    });

    on<StopListening>((event, emit) async {
      print('[MessagesBloc] StopListening event received');
      await _subMessage?.cancel();
      await _subInRoom?.cancel();
      print('[MessagesBloc] Stream subscription canceled');
      _subMessage = null;
      _subInRoom = null;
    });
  }

  @override
  Future<void> close() {
    print('[MessagesBloc] close called, canceling subscription if exists');
    _subMessage?.cancel();
    return super.close();
  }
}
