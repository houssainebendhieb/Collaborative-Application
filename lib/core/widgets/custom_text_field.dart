import 'package:flutter/material.dart';
import 'package:google_docs_clone/core/styles/custom_decoration_text_field.dart';

class custom_text_field extends StatelessWidget {
  custom_text_field({
    this.textInputType,
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;
  String? textInputType = "email";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: textInputType != null && textInputType == "email"
          ? TextInputType.emailAddress
          : textInputType != null && textInputType == "number"
              ? TextInputType.number
              : TextInputType.text,
      decoration: CustomDecorationTextField.inputDecoration("Email"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
    );
  }
}
