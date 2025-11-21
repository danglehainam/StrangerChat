import 'package:chat/src/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl implements UserRepository{
  final _firestore = FirebaseFirestore.instance;
  @override
  Future<void> deleteUser(String uid) async{
    await _firestore.collection("users").doc(uid).delete();
    await FirebaseAuth.instance.currentUser!.delete();
  }

  @override
  Future<Map<String, dynamic>?> getUser(String uid) async{
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data();
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async{
    await _firestore.collection("users").doc(uid).update(data);
  }
}