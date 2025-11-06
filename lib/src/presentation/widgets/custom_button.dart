import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String text;
  final bool loading;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.loading = false,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIndicator() : Text(text),
    );

  }

}