import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_message_models.dart';
import '../../domain/repositories/chat_repository.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_event.dart';
import '../blocs/chat/chat_state.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  const ChatScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesBloc(repo: ChatRepository())..add(StartListening()),
      child: Scaffold(
        appBar: AppBar(title: Text('Chat')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessagesBloc, MessagesState>(
                builder: (context, state) {
                  if (state is MessagesLoadInProgress) return Center(child: CircularProgressIndicator());
                  if (state is MessagesLoadSuccess) {
                    if (state.messages.isEmpty) {
                      return Center(child: Text('Không có tin nhắn nào'));
                    }else{
                      final list = state.messages;
                      return ListView.builder(
                        reverse: false,
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          final m = list[idx];
                          final mine = m.senderId == currentUserId;
                          return Align(
                            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Card(child: Padding(padding: EdgeInsets.all(8), child: Text(m.text))),
                          );
                        },
                      );
                    }
                  }
                  if (state is MessagesFailure) return Text('Lỗi: ${state.error}');
                  return SizedBox.shrink();
                },
              ),
            ),
            _MessageComposer(currentUserId: currentUserId),
          ],
        ),
      ),
    );
  }
}

class _MessageComposer extends StatefulWidget {
  final String currentUserId;
  const _MessageComposer({required this.currentUserId});

  @override
  State<_MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<_MessageComposer> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(child: TextField(controller: _controller)),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              final msg = ChatMessage(
                id: '', // repo will push and set key
                senderId: widget.currentUserId,
                text: text,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );
              context.read<MessagesBloc>().add(SendMessageEvent(msg));
              _controller.clear();
            },
          )
        ],
      ),
    );
  }
}
