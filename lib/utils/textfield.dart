import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String labelText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController controller;

  ReusableTextField({
    Key? key,
    required this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 19,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      ),
      obscureText: obscureText,
    );
  }
}
