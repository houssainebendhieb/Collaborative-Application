import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/styles/custom_decoration_text_field.dart';
import 'package:google_docs_clone/core/widgets/custom_text_field.dart';
import 'package:google_docs_clone/feature/auth/data/cubit/user_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "SignUp For Free",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Email TextField
                custom_text_field(emailController: emailController),
                const SizedBox(height: 16),

                // Password TextField
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration:
                      CustomDecorationTextField.inputDecoration("Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Perform login action
                      bool correctSignUp = await context
                          .read<UserCubit>()
                          .SignUp(
                              email: emailController.text.trim().toLowerCase(),
                              password: passwordController.text.trim());
                      if (correctSignUp) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("SignUp", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  if (state is UserSignUpFailure) {
                    Future(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.blue,
                      ));
                    });
                  }
                  return const Text("");
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
