import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/user/user_event.dart';
import '../blocs/user/user_state.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String gender = "Nam";

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin người dùng")),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is UserFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserLoaded) {
              nameCtrl.text = state.name;
              ageCtrl.text = state.age.toString();
              gender = state.gender;
            }

            if (state is UserLoaded || state is UserSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Tên",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: ageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Tuổi",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Giới tính"),
                    Row(
                      children: [
                        Radio<String>(
                          value: "Nam",
                          groupValue: gender,
                          onChanged: (v) => setState(() => gender = v!),
                        ),
                        const Text("Nam"),
                        Radio<String>(
                          value: "Nữ",
                          groupValue: gender,
                          onChanged: (v) => setState(() => gender = v!),
                        ),
                        const Text("Nữ"),
                        Radio<String>(
                          value: "Khác",
                          groupValue: gender,
                          onChanged: (v) => setState(() => gender = v!),
                        ),
                        const Text("Khác"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(
                          UpdateUserEvent(
                            uid: widget.uid,
                            name: nameCtrl.text,
                            age: int.tryParse(ageCtrl.text) ?? 0,
                            gender: gender,
                          ),
                        );
                      },
                      child: const Text("Lưu thay đổi"),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<UserBloc>()
                            .add(DeleteUserEvent(widget.uid));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Xóa tài khoản"),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Không có dữ liệu"));
          },
        ),
      ),
    );
  }
}
