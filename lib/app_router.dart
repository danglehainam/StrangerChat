import 'package:chat/src/presentation/screens/register_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);
