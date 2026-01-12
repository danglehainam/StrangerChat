// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/chat/chat_bloc.dart';
// import '../blocs/chat/chat_state.dart';
// import 'chat_message_widget.dart';
//
// class MessagesListWidget extends StatelessWidget {
//   final String currentUserId;
//
//   const MessagesListWidget({required this.currentUserId, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatBloc, ChatState>(
//       buildWhen: (previous, current) {
//         return current is MessagesLoadSuccess;
//       },
//       builder: (context, state) {
//         if (state is MessagesLoadInProgress) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is MessagesLoadSuccess) {
//           final messages = state.messages;
//           if (messages.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Hãy gửi “Xin chào 👋” để bắt đầu cuộc trò chuyện',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             reverse: true,
//             itemCount: messages.length,
//             itemBuilder: (context, idx) {
//               final msg = messages[messages.length - 1 - idx];
//               final isMine = msg.senderId == currentUserId;
//
//               return ChatMessageWidget(
//                 key: ValueKey(msg.id),
//                 message: msg,
//                 mine: isMine,
//                 onTap: () {
//                   print('Clicked message: ${msg.text}');
//                 },
//                 onLongPress: () {
//                   print('Long pressed message: ${msg.text}');
//                   // show menu delete / copy / etc.
//                 },
//               );
//             },
//           );
//         }
//
//         if (state is Error) {
//           return Center(
//             child: Text(
//               'Lỗi: ${state.error}',
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }
//
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
