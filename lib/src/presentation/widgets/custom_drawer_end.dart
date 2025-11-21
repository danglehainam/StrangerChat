import 'package:chat/src/core/utils/toast_utils.dart';
import 'package:chat/src/data/datasources/remote/chat_message_remote.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../data/datasources/local/chat_message_local.dart';
import '../../data/repositories_impl/chat_repository_impl.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'confirm_dialog.dart';

class CustomDrawerEnd extends StatelessWidget {
  const CustomDrawerEnd({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService().getCurrentUser();
    final chatRepo = ChatRepositoryImpl(
      ChatMessageLocal(objectbox.store.box<ChatMessageEntity>()),
      ChatMessageRemote(),
    );
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
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              context.push('/login');
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
              'End chat',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              bool confirm = await showConfirmDialog(
                context,
                title: "Bạn có chắc muốn thoát?",
                content: "Bạn sẽ mất lịch sử trò chuyện có thể sẽ không tìm lại được người này sau khi thoát!",
                cancelText: "Không",
                confirmText: "Xác nhận",
                confirmColor: Colors.red,
              );
              if (confirm) {
                try {
                  print('Xác nhận thoát');
                  final end = await chatRepo.endChat();
                  if(end){
                    GoRouter.of(context).go('/find', extra: user!.uid);
                    Navigator.pop(context);
                    showToast(context, 'Đã thoát cuộc trò chuyện', isError: false);
                  }
                  else{
                    Navigator.pop(context);
                    showToast(context, 'Lỗi khi thoát', isError: true);
                  }
                } catch (e) {
                  print('Lỗi khi thoát: $e');
                }
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
