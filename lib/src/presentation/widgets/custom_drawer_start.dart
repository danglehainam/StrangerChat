import 'package:chat/src/data/datasources/remote/chat_message_remote.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/fcm_token_manager.dart';
import '../../core/services/firebase_auth_service.dart';
import 'confirm_dialog.dart';

class CustomDrawerStart extends StatelessWidget {
  const CustomDrawerStart({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService().getCurrentUser();
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            accountName: Text(
              user?.displayName ?? "No Name",
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              user?.email ?? "No Email",
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
          ),

          // --- Menu Items ---
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Tài khoản'),
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              context.push('/home');
            },
          ),
          const Spacer(),
          // --- Logout Button ---
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              bool confirm = await showConfirmDialog(
                context,
                title: "Đăng xuất",
                content: "Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?",
                cancelText: "Không",
                confirmText: "Đăng xuất",
                confirmColor: Colors.red,
              );
              if (confirm) {
                print('Xác nhận đăng xuất');
                await ChatMessageRemote().dispose();
                print('[Confirm Logout] dispose');
                final fcmToken = await FirebaseMessaging.instance.getToken();
                print('[Confirm Logout] fcmToken: $fcmToken');
                if (fcmToken != null) {
                  print('[Confirm Logout] uid: ${user?.uid}');
                  final dbRef = FirebaseDatabase.instance.ref('users/${user?.uid}/tokens/$fcmToken');
                  try {
                    await dbRef.remove();
                    print('[Confirm Logout] remove token from RTDB done');
                  } catch (e) {
                    print('[Confirm Logout] ERROR removing token: $e');
                  }
                }
                FCMTokenManager().stopListening();
                print('[Confirm Logout] stopListening');
                await FirebaseAuthService().logout();
                print('[Confirm Logout] logout');
                GoRouter.of(context).go('/login');
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
