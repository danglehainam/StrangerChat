import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/fcm_token_manager.dart';
import '../../core/services/firebase_match_service.dart';
import '../../data/datasources/remote/chat_message_remote.dart';
import '../blocs/match/match_bloc.dart';
import '../blocs/match/match_event.dart';
import '../blocs/match/match_state.dart';

class FindScreen extends StatelessWidget {
  final String uid;
  const FindScreen({required this.uid, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchBloc(
        chatRemote: context.read<ChatMessageRemote>(),
        firebase: context.read<FirebaseMatchService>(),
      ),
      child: BlocConsumer<MatchBloc, MatchState>(
        listener: (context, state) {
          if (state is MatchFound) {
            FCMTokenManager().startListening();
            context.go('/chat', extra: state.roomId);
          }
        },
        builder: (context, state) {
          if (state is MatchInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<MatchBloc>().add(StartFindEvent(uid));
                },
                child: Text("Tìm người để chat"),
              ),
            );
          } else if (state is MatchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MatchWaiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Đang tìm người phù hợp..."),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MatchBloc>().add(StopFindEvent(uid));
                    },
                    child: Text("Ngừng tìm"),
                  ),
                ],
              ),
            );
          } else if (state is MatchError) {
            return Center(
              child: Text("Lỗi: ${state.message}"),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
