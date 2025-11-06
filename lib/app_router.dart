import 'package:chat/src/presentation/screens/chat_page.dart';
import 'package:chat/src/presentation/screens/login_page.dart';
import 'package:chat/src/presentation/screens/register_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/register',
  routes: [
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final currentUserId = state.extra as String; // lấy userId truyền vô
        return ChatScreen(currentUserId: currentUserId);
      },
    )
  ],
);
