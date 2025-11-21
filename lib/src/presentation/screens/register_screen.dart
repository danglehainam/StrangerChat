import 'package:chat/src/presentation/widgets/custom_button.dart';
import 'package:chat/src/presentation/widgets/custom_drawer_start.dart';
import 'package:chat/src/presentation/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/toast_utils.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/verify_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _cfmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const CustomDrawerStart(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showToast(context, state.error, isError: true);
          } else if (state is AuthSuccess) {
            showToast(context, state.message);
            showDialog(
              context: context,
              builder: (_) => VerifyDialog(
                onSubmit: (code) {
                  context.read<AuthBloc>().add(
                    VerifyUserEvent(_emailCtrl.text.trim(), code),
                  );
                },
              ),
            );
          } else if (state is AuthVerifySuccess) {
            showToast(context, state.message);
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header / Logo
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person_add, size: 60, color: Colors.blueAccent),
                      SizedBox(height: 10),
                      Text(
                        "Tạo tài khoản mới",
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
                          label: "Email",
                        ),
                        const SizedBox(height: 16),
                        CustomInput(
                          controller: _usernameCtrl,
                          label: "Username",
                        ),
                        const SizedBox(height: 16),
                        CustomInput(
                          controller: _passwordCtrl,
                          obscureText: true,
                          label: "Password",
                        ),
                        const SizedBox(height: 16),
                        CustomInput(
                          controller: _cfmPasswordCtrl,
                          obscureText: true,
                          label: "Confirm Password",
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Đăng ký',
                          loading: loading,
                          onPressed: loading
                              ? null
                              : () {
                            context.read<AuthBloc>().add(
                              RegisterEvent(
                                _emailCtrl.text.trim(),
                                _usernameCtrl.text.trim(),
                                _passwordCtrl.text.trim(),
                                _cfmPasswordCtrl.text.trim(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Đã có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
