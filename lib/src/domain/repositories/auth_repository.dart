abstract class AuthRepository{
  Future<Map<String, dynamic>> register(String email, String username, String password);
  Future<Map<String, dynamic>> verifyUser(String email, String code);
  Future<Map<String, dynamic>> loginWithCustomToken(String username, String password);
}