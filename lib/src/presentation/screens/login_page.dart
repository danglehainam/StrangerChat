import 'package:chat/src/core/utils/toast_utils.dart';
import 'package:chat/src/presentation/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          listener: (context, state){
            if(state is AuthError){
              showToast(context, state.error, isError: true);
            }
            else if(state is AuthSuccess){
              showToast(context, state.message);
              context.push('/chat', extra: 'userId2');
            }
          },
          builder: (context, state) {
            final loading = state is AuthLoading;
            return(
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomInput(
                      controller: _emailCtrl,
                      label: "Email hoặc username",
                    ),
                    const SizedBox(height: 20),
                    CustomInput(
                      controller: _passwordCtrl,
                      label: "Mật khẩu",
                    ),
                    const SizedBox(height: 20),
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
                  ]
                ),
              )
            );
          }
      )
    );
  }
}
