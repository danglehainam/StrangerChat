abstract class UserRepository{
  Future<Map<String, dynamic>?> getUser(String uid);
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  Future<void> deleteUser(String uid);
}