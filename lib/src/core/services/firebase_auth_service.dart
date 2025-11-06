import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;  // Trả về user nếu đăng nhập thành công
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi cụ thể
      if (e.code == 'user-not-found') {
        throw Exception("Không tìm thấy người dùng với email này");
      } else if (e.code == 'wrong-password') {
        throw Exception("Sai mật khẩu");
      } else if (e.code == 'invalid-email') {
        throw Exception("Email không hợp lệ");
      } else {
        throw Exception("Lỗi đăng nhập: ${e.message}");
      }
    } catch (e) {
      throw Exception("Lỗi đăng nhập không xác định: $e");
    }
  }

  //Đăng nhập với customtoken
  Future<User?> signInWithCustomToken(String customToken) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithCustomToken(customToken);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Firebase Auth error: ${e.message}");
    } catch (e) {
      throw Exception("Đăng nhập thất bại: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Đăng xuất thất bại: $e");
    }
  }
}
