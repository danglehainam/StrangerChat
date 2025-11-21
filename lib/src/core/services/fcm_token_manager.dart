import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMTokenManager {
  // Singleton
  static final FCMTokenManager _instance = FCMTokenManager._internal();
  factory FCMTokenManager() => _instance;
  FCMTokenManager._internal();

  StreamSubscription<String>? _tokenStream;

  /// Thêm token mới vào RTDB (cho phép nhiều token)
  Future<void> _saveToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance
        .ref("users/${user.uid}/tokens/$token");

    await ref.set(true); // giá trị có thể là timestamp hoặc true
    print("🔥 Token saved to RTDB: $token");
  }

  /// Khởi động việc lắng nghe token
  Future<void> startListening() async {
    // Nếu đang lắng nghe rồi → không tạo thêm
    if (_tokenStream != null) {
      print("⚠ Token listener is already active.");
      return;
    }

    print("📡 Starting FCM token listener...");

    // Lấy token hiện tại ngay khi vào màn hình
    final currentToken = await FirebaseMessaging.instance.getToken();
    if (currentToken != null) {
      await _saveToken(currentToken);
    }

    // Lắng nghe token refresh
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 FCM token refreshed: $newToken");
      _saveToken(newToken);
    });
  }

  /// Dừng lắng nghe (khi rời màn hình)
  void stopListening() {
    _tokenStream?.cancel();
    _tokenStream = null;
    print("🛑 Stopped FCM token listener.");
  }
}
