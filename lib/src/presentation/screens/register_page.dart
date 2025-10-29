import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/toast_utils.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/verify_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
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
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(labelText: "Tên đăng nhập"),
                ),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Mật khẩu"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () {
                    context.read<AuthBloc>().add(
                      RegisterEvent(
                        _emailCtrl.text.trim(),
                        _usernameCtrl.text.trim(),
                        _passwordCtrl.text.trim(),
                      ),
                    );
                  },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Đăng ký"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
