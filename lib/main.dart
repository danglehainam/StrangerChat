import 'package:chat/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:chat/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_router.dart';
import 'firebase_options.dart';

Future<void> main()async {
  await dotenv.load(fileName: ".env");
  try {
    print('🚀 [MAIN] Starting app...');
    WidgetsFlutterBinding.ensureInitialized();
    print('✅ [MAIN] WidgetsFlutterBinding initialized');

    // Initialize Firebase
    print('🔥 [MAIN] Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ [MAIN] Firebase initialized');

    print('🎯 [MAIN] Running app...');
    runApp(MyApp());
  } catch (e, stackTrace) {
    print('❌ [MAIN] Error during initialization: $e');
    print('📋 [MAIN] Stack trace: $stackTrace');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Lỗi khởi tạo ứng dụng',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text('$e'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart app
                    main();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final repo = AuthRepositoryImpl();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(repo),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        title: 'Đăng ký Demo',
      ),
    );
  }
}
