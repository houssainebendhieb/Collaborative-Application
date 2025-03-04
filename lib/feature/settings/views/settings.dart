import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/auth/data/cubit/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final SharedPreferences sharedPreferences = getIt.get<SharedPreferences>();
  @override
  Widget build(BuildContext context) {
    emailController.text = sharedPreferences.getString("email") ?? " ";
    String email = sharedPreferences.getString("email") ?? " ";
    passwordController.text = sharedPreferences.getString("password") ?? " ";
    usernameController.text = sharedPreferences.getString("username") ?? " ";
    String password = sharedPreferences.getString("password") ?? " ";
    String username = sharedPreferences.getString("username") ?? "";
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      context.read<UserCubit>().SignOut();
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.blue))
              ],
            ),
            const SizedBox(
              height: 150,
            ),
            const Text("username"),
            TextField(
              readOnly: false,
              controller: usernameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Email"),
            TextField(
              readOnly: true,
              controller: emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("password"),
            TextField(
              readOnly: true,
              controller: passwordController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          emailController.text = email;
                          passwordController.text = password;
                          usernameController.text = username;
                        },
                        child: const Text("Cancel"))),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<UserCubit>()
                              .updateProfile(username: usernameController.text);
                        },
                        child: const Text("Update"))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
