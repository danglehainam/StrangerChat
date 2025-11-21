import 'package:flutter/material.dart';
import '../../data/models/chat_message_models.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageEntity message;
  final bool mine;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.mine,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: mine ? const Color(0xFF0078FF) : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: mine ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight: mine ? const Radius.circular(0) : const Radius.circular(16),
            ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: mine ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
