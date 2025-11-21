import 'package:chat/src/core/services/firebase_auth_service.dart';
import 'package:chat/src/data/datasources/local/chat_message_local.dart';
import 'package:chat/src/data/repositories_impl/chat_repository_impl.dart';
import 'package:chat/src/presentation/widgets/custom_drawer_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';
import '../../data/models/chat_message_models.dart';
import '../../data/datasources/remote/chat_message_remote.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_event.dart';
import '../blocs/chat/chat_state.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/custom_drawer_end.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();
    final chatRepo = ChatRepositoryImpl(
      ChatMessageLocal(objectbox.store.box<ChatMessageEntity>()),
      ChatMessageRemote(),
    );
    return BlocProvider(
      create: (_) => MessagesBloc(repo: chatRepo)..add(StartListening(roomId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: const Text('Trò chuyện'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          actions: [
            Builder(builder: (context){
              return IconButton(
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            })
          ],
        ),
        drawer: const CustomDrawerStart(),
        endDrawer: const CustomDrawerEnd(),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessagesBloc, MessagesState>(
                builder: (context, state) {
                  if (state is MessagesLoadInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MessagesLoadSuccess) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'Hãy gửi “Xin chào 👋” để bắt đầu cuộc trò chuyện',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    } else {
                      final list = state.messages;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        reverse: true,
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          final m = list[list.length - 1 - idx];
                          final mine = m.senderId == authService.getCurrentUser()?.uid;
                          return ChatMessageWidget(
                            message: m,
                            mine: mine,
                            onTap: () {
                              print('Clicked message: ${m.text}');
                            },
                            onLongPress: () {
                              print('Long pressed message: ${m.text}');
                              // ví dụ: show bottom sheet, menu delete, copy text...
                            },
                          );
                        },
                      );
                    }
                  }
                  if (state is MessagesFailure) {
                    return Center(
                      child: Text(
                        'Lỗi: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (state is EndChatState) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/find', extra: authService.getCurrentUser()!.uid);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Không có dữ liệu'));
                },
              ),
            ),
            _MessageComposer(userId: authService.getCurrentUser()!.uid, roomId: roomId),
          ],
        ),
      ),
    );
  }
}

class _MessageComposer extends StatefulWidget {
  final String userId;
  final String roomId;
  const _MessageComposer({required this.userId, required this.roomId});

  @override
  State<_MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<_MessageComposer> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(context),
                ),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF0078FF),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessageModel(
      id: '',
      senderId: widget.userId,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    context.read<MessagesBloc>().add(SendMessageEvent(msg, widget.roomId));
    _controller.clear();
  }
}
