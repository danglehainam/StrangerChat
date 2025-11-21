import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel {
  String? id;
  final String senderId;
  final String text;
  final int timestamp;
  final String? imageUrl;

  ChatMessageModel({
    this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'text': text,
    'timestamp': timestamp,
    'imageUrl': imageUrl,
  };

  factory ChatMessageModel.fromSnapshot(String id, Map<dynamic, dynamic> map) {
    return ChatMessageModel(
      id: id,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: map['timestamp'] as int? ?? 0,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  ChatMessageEntity toEntity() {
    // PHẢI đảm bảo id (String) tồn tại, nếu không có ID từ API (lần đầu gửi)
    // bạn cần gán một giá trị tạm thời hoặc tạo một ID ngẫu nhiên.
    // Ở đây ta giả định rằng id luôn tồn tại khi lưu vào DB cục bộ.
    // Nếu id là null, bạn cần xử lý (ví dụ: throw lỗi hoặc gán UUID mới).
    if (id == null) {
      throw Exception("Cannot convert Model to Entity: Model ID is null.");
    }

    return ChatMessageEntity(
      messageId: id!, // Dùng id của Model làm messageId của Entity
      senderId: senderId,
      text: text,
      timestamp: timestamp,
      imageUrl: imageUrl,
    );
  }
}
