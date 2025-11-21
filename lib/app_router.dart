import 'package:chat/src/data/repositories_impl/user_repository_impl.dart';
import 'package:chat/src/presentation/blocs/user/user_bloc.dart';
import 'package:chat/src/presentation/screens/chat_screen.dart';
import 'package:chat/src/presentation/screens/find_screen.dart';
import 'package:chat/src/presentation/screens/login_screen.dart';
import 'package:chat/src/presentation/screens/register_screen.dart';
import 'package:chat/src/presentation/screens/splash_screen.dart';
import 'package:chat/src/presentation/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/find',
      builder: (context, state) {
        final userId = state.extra as String;
        return FindScreen(uid: userId);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final roomId = state.extra as String;
        return ChatScreen(roomId: roomId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => UserBloc(UserRepositoryImpl()),
          child: UserProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        );
      },
    ),
  ],
);
