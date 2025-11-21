import 'dart:async';
import 'package:chat/src/data/datasources/remote/chat_message_remote.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firebase_match_service.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final ChatMessageRemote chatRemote;
  final FirebaseMatchService firebase;
  StreamSubscription<DatabaseEvent>? _listener;

  MatchBloc({required this.chatRemote, required this.firebase}) : super(MatchInitial()) {
    on<StartFindEvent>(_onStartFind);
    on<StopFindEvent>(_onStopFind);
    on<RoomFoundEvent>((event, emit) {
      final roomId = event.roomId;
      if (roomId != null) {
        emit(MatchFound(roomId));
      } else {
        emit(MatchError("RoomId null"));
      }
    });
  }

  Future<void> _onStartFind(StartFindEvent event, Emitter<MatchState> emit) async {
    emit(MatchLoading());
    try {

      final result = await chatRemote.findMatch();

      if (result["matched"] == true && result["roomId"] != null) {
        emit(MatchFound(result["roomId"]));
      } else if (result["status"] == "waiting") {
        emit(MatchWaiting());
        _listener = firebase.listenForRoom(event.uid, (roomId) {
          if (roomId != null) {
            add(RoomFoundEvent(roomId));
          }
        });
      } else {
        emit(MatchError("Không xác định được trạng thái"));
      }
    } catch (e) {
      emit(MatchError(e.toString()));
    }
  }

  Future<void> _onStopFind(StopFindEvent event, Emitter<MatchState> emit) async {
    await chatRemote.leaveQueue();
    await _listener?.cancel();
    emit(MatchInitial());
  }

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }
}