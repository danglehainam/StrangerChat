// // chat_bottom.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../blocs/chat/chat_bloc.dart';
// import '../blocs/chat/chat_state.dart';
// import '../blocs/chat/chat_event.dart';
// import '../../data/models/chat_message_models.dart';
//
// class ChatBottomWidget extends StatelessWidget {
//   final String userId;
//   const ChatBottomWidget({super.key, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatBloc, ChatState>(
//       // Chỉ rebuild khi trạng thái match thay đổi
//       buildWhen: (previous, current) =>
//           current is MatchFound ||
//           current is MatchWaiting ||
//           current is MatchEnd,
//       builder: (context, state) {
//         // 1) Có match => hiển thị composer nhập tin nhắn
//         if (state is MatchFound) {
//           final roomId = state.roomId;
//           return _wrapSafeArea(
//             child: _Composer(
//               userId: userId,
//               roomId: roomId,
//             ),
//           );
//         }
//
//         // 2) Đang tìm người
//         if (state is MatchWaiting) {
//           return _wrapSafeArea(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                   SizedBox(width: 12),
//                   Text(
//                     'Đang tìm người trò chuyện...',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // 3) Không trong phòng — hiển thị nút tìm người
//         if (state is MatchEnd) {
//           return _wrapSafeArea(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.read<ChatBloc>().add(StartFindEvent(userId));
//                 },
//                 child: const Text("Tìm người trò chuyện"),
//               ),
//             ),
//           );
//         }
//
//         // 4) Mặc định: không chiếm diện tích
//         return const SizedBox.shrink();
//       },
//     );
//   }
//
//   Widget _wrapSafeArea({required Widget child}) {
//     return SafeArea(
//       child: Container(
//         color: Colors.white,
//         child: child,
//       ),
//     );
//   }
// }
//
// class _Composer extends StatefulWidget {
//   final String userId;
//   final String roomId;
//
//   const _Composer({
//     required this.userId,
//     required this.roomId,
//   });
//
//   @override
//   State<_Composer> createState() => __ComposerState();
// }
//
// class __ComposerState extends State<_Composer> {
//   final _controller = TextEditingController();
//
//   void _send() {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//
//     final msg = ChatMessageModel(
//       id: '',
//       senderId: widget.userId,
//       text: text,
//       timestamp: DateTime.now().millisecondsSinceEpoch,
//     );
//
//     context.read<ChatBloc>().add(
//       SendMessageEvent(msg, widget.roomId),
//     );
//
//     _controller.clear();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF1F3F6),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: TextField(
//                 controller: _controller,
//                 textInputAction: TextInputAction.send,
//                 decoration: const InputDecoration(
//                   hintText: 'Nhập tin nhắn...',
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (_) => _send(),
//               ),
//             ),
//           ),
//           const SizedBox(width: 6),
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: const Color(0xFF0078FF),
//             child: IconButton(
//               icon: const Icon(Icons.send, color: Colors.white, size: 20),
//               onPressed: _send,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
