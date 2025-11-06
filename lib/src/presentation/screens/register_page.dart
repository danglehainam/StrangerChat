import 'package:chat/src/presentation/widgets/custom_button.dart';
import 'package:chat/src/presentation/widgets/custom_drawer.dart';
import 'package:chat/src/presentation/widgets/custom_input.dart';
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
  final _cfmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      drawer: const CustomDrawer(),
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
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomInput(
                  controller: _emailCtrl,
                  label: "Email",
                ),
                const SizedBox(height: 20),
                CustomInput(
                  controller: _usernameCtrl,
                  label: "Username",
                ),
                const SizedBox(height: 20),
                CustomInput(
                  controller: _passwordCtrl,
                  obscureText: true,
                  label: "Password",
                ),
                const SizedBox(height: 20),
                CustomInput(
                  controller: _cfmPasswordCtrl,
                  obscureText: true,
                  label: "Confirm Password",
                ),
                const SizedBox(height: 20),
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
          );
        },
      ),
    );
  }
}
