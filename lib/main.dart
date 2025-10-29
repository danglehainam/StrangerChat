import 'package:chat/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:chat/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_router.dart';

Future<void> main()async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final repo = AuthRepositoryImpl();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(repo),
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Đăng ký Demo',
      ),
    );
  }
}
