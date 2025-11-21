import 'package:chat/src/core/utils/toast_utils.dart';
import 'package:chat/src/presentation/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showToast(context, state.error, isError: true);
          }
          else if (state is AuthSuccessToFind) {
            showToast(context, 'Đăng nhập thành công!');
            context.push('/find', extra: state.uid);
          }
          else if (state is AuthSuccessToChat) {
            showToast(context, 'Đăng nhập thành công!');
            context.push('/chat', extra: state.roomId);
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.login, size: 60, color: Colors.blueAccent),
                      SizedBox(height: 10),
                      Text(
                        "Chào mừng quay trở lại",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Form container
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CustomInput(
                          controller: _emailCtrl,
                          label: "Email hoặc username",
                        ),
                        const SizedBox(height: 16),
                        CustomInput(
                          controller: _passwordCtrl,
                          label: "Mật khẩu",
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Đăng nhập',
                          loading: loading,
                          onPressed: loading
                              ? null
                              : () {
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                _emailCtrl.text.trim(),
                                _passwordCtrl.text.trim(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Footer: register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        context.push('/register');
                      },
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
