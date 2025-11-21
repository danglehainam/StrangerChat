import 'package:chat/objectbox.g.dart';
import 'package:chat/src/domain/entities/chat_message_entity.dart';

class ChatMessageLocal {
  final Box<ChatMessageEntity> chatMessageBox;

  ChatMessageLocal(this.chatMessageBox);

  int saveMessage(ChatMessageEntity message) {
    print('ChatMessageLocal.saveMessage(): $message');
    return chatMessageBox.put(message);
  }

  List<int> saveMessages(List<ChatMessageEntity> messages) {
    return chatMessageBox.putMany(messages);
  }

  ChatMessageEntity? getMessageById(int id) {
    return chatMessageBox.get(id);
  }

  List<ChatMessageEntity> getListMessages() {
    final query = chatMessageBox
        .query()
        .order(ChatMessageEntity_.timestamp)
        .build();

    final results = query.find();
    query.close();
    return results;
  }

  int getLatestLocalTimestamp(Box<ChatMessageEntity> box) {
    final query = box.query()
        .order(ChatMessageEntity_.timestamp, flags: Order.descending)
        .build();

    final last = query.findFirst();
    return last?.timestamp ?? 0;
  }

  bool removeMessage(int id) {
    return chatMessageBox.remove(id);
  }

  int removeMessages(List<int> ids) {
    return chatMessageBox.removeMany(ids);
  }

  int removeAllMessages() {
    return chatMessageBox.removeAll();
  }
}