import 'package:flutter/material.dart';
import 'package:google_docs_clone/core/styles/custom_decoration_text_field.dart';

class custom_text_field extends StatelessWidget {
  const custom_text_field({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration:
          CustomDecorationTextField.inputDecoration("Email"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
    );
  }
}
