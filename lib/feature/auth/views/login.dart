import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/styles/custom_decoration_text_field.dart';
import 'package:google_docs_clone/core/widgets/custom_text_field.dart';
import 'package:google_docs_clone/feature/auth/data/cubit/user_cubit.dart';
import 'package:google_docs_clone/feature/auth/views/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  "Welcome Back!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Email TextField
                custom_text_field(
                    textInputType: "email", emailController: emailController),
                const SizedBox(height: 16),

                // Password TextField
                custom_text_field(
                  emailController: passwordController,
                  textInputType: "email",
                ),
                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform login action
                      context.read<UserCubit>().login(
                          context: context,
                          email: emailController.text.trim().toLowerCase(),
                          password: passwordController.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),

                // Sign Up Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) => UserCubit(),
                                  child: const SignUpScreen(),
                                )));
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  if (state is UserLoginFailure) {
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
