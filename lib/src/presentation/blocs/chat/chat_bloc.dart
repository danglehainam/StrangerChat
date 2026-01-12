import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/models/chat_message_models.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepositoryImpl repo;
  StreamSubscription<ChatMessageModel>? _subMessage;
  StreamSubscription<bool>? _subInRoom;


  ChatBloc({required this.repo}) : super(MessagesInitial()) {
    on<ChatInit>((event, emit) async{
      emit(MessagesLoadInProgress());
      await repo.saveNewMessageToLocal();
      print('[ChatBloc] Sync done.');
      final localMessages = repo.getLocalMessages();
      print('[ChatBloc] Local messages: $localMessages');
      emit(MessagesLoadSuccess(localMessages));
      print('[ChatBloc] Syncing new messages to local...');
    });

    on<StartListening>((event, emit) async {
      print('[ChatBloc] StartListening event received');
      _subMessage ??= repo.listenAndSaveMessages(event.roomId).listen(
            (msg) {
          add(MessagesUpdated([msg.toEntity()]));
        },
        onError: (e) => addError(e),
      );
      print('[ChatBloc] Subscribed to messages stream');
      _subInRoom ??= repo.isInRoomStream(event.roomId).listen((isInRoom) {
          add(EndChatEvent(isInRoom));
        },
        onError: (e) => addError(e),
      );
    });
    print('[ChatBloc] Subscribed to is in room stream');

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
      print('[ChatBloc] SendMessageEvent received with message: ${event.message}');
      try {
        await repo.sendMessage(event.roomId, event.message);
        print('[ChatBloc] Message sent successfully');
      } catch (e) {
        print('[ChatBloc] Error sending message: $e');
        emit(MessagesFailure(e.toString()));
      }
    });

    on<StopListening>((event, emit) async {
      print('[ChatBloc] StopListening event received');
      await _subMessage?.cancel();
      await _subInRoom?.cancel();
      print('[ChatBloc] Stream subscription canceled');
      _subMessage = null;
      _subInRoom = null;
    });
  }

  @override
  Future<void> close() {
    print('[ChatBloc] close called, canceling subscription if exists');
    _subMessage?.cancel();
    return super.close();
  }
}
