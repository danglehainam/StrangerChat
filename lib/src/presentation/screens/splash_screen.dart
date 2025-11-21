import 'package:chat/src/data/datasources/remote/chat_message_remote.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/fcm_token_manager.dart';
import '../../core/services/firebase_auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = FirebaseAuthService();
  final chatRemote = ChatMessageRemote();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final delay = Future.delayed(const Duration(seconds: 1));
    final user = await _authService.getCurrentUser();
    await delay;
    if (user == null) {
      context.go('/login');
    } else {
      final roomId = await chatRemote.getCurrentRoom(user.uid);
      if (roomId != null) {
        FCMTokenManager().startListening();
        context.go('/chat', extra: roomId);
      } else {
        context.go('/find', extra: user.uid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Chat App",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
