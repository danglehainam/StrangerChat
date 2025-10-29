import 'package:flutter/material.dart';

class VerifyDialog extends StatefulWidget {
  final Function(String code) onSubmit;

  const VerifyDialog({super.key, required this.onSubmit});

  @override
  State<VerifyDialog> createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<VerifyDialog> {
  final _codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nhập mã xác thực"),
      content: TextField(
        controller: _codeCtrl,
        decoration: const InputDecoration(labelText: "Mã OTP"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Huỷ"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_codeCtrl.text.trim());
            Navigator.pop(context);
          },
          child: const Text("Xác nhận"),
        ),
      ],
    );
  }
}
