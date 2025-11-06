class ChatMessage {
  final String id; // push key
  final String senderId;
  final String text;
  final int timestamp;
  final String? imageUrl;

  ChatMessage({
    required this.id,
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

  factory ChatMessage.fromSnapshot(String id, Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: id,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: (map['timestamp'] as int?) ?? 0,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}
