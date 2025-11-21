import 'package:chat/src/core/services/firebase_match_service.dart';
import 'package:chat/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:chat/src/data/datasources/remote/chat_message_remote.dart';
import 'package:chat/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_router.dart';
import 'firebase_options.dart';
import 'object_box.dart';

late ObjectBox objectbox;
Future<void> main()async {
  try {
    print('🚀 [MAIN] Starting app...');
    WidgetsFlutterBinding.ensureInitialized();
    print('✅ [MAIN] WidgetsFlutterBinding initialized');
    await dotenv.load(fileName: ".env");
    objectbox = await ObjectBox.create();
    print('✅ [MAIN] Objectbox initialized');
    print('🔥 [MAIN] Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
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
  MyApp({super.key});

  final authRepo = AuthRepositoryImpl();
  final matchRepo = ChatMessageRemote();
  final firebaseService = FirebaseMatchService();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepo),
        RepositoryProvider<ChatMessageRemote>.value(value: matchRepo),
        RepositoryProvider<FirebaseMatchService>.value(value: firebaseService),
      ],
      child: BlocProvider(
        create: (_) => AuthBloc(authRepo),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          title: 'Chat Demo',
        ),
      ),
    );
  }
}
