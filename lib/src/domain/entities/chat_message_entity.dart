import 'package:objectbox/objectbox.dart';

import '../../data/models/chat_message_models.dart';

@Entity()
class ChatMessageEntity{
  @Id()
  int id = 0;
  @Unique()
  String messageId;
  String senderId;
  String text;
  int timestamp;
  String? imageUrl;

  ChatMessageEntity({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.imageUrl,
  });

  ChatMessageModel toModel() {
    return ChatMessageModel(
      id: messageId, // Dùng messageId của Entity làm id của Model
      senderId: senderId,
      text: text,
      timestamp: timestamp,
      imageUrl: imageUrl,
    );
  }
}