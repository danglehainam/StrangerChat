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
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
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

  User? getCurrentUser() {
    try {
      User? user = _auth.currentUser;
      return user;
    } catch (e) {
      throw Exception("Lỗi lấy thông tin người dùng: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
