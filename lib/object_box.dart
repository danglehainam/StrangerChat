
import 'package:chat/src/domain/entities/chat_message_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'objectbox.g.dart';

class ObjectBox {
  /// Store là nơi lưu trữ toàn bộ cơ sở dữ liệu
  late final Store store;

  // Lớp Box (tương đương bảng) cho Entity ChatMessage
  late final Box<ChatMessageEntity> chatMessageBox;

  ObjectBox._create(this.store) {
    // Khởi tạo Box (chú ý: Box phải được khởi tạo sau Store)
    chatMessageBox = store.box<ChatMessageEntity>();
  }

  /// Khởi tạo ObjectBox Store
  static Future<ObjectBox> create() async {
    // Tìm đường dẫn để lưu trữ file DB
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, "objectbox-db");

    // openStore() được định nghĩa trong objectbox.g.dart
    final store = await openStore(directory: dbPath);

    return ObjectBox._create(store);
  }
}