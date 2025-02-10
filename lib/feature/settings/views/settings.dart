import 'package:firebase_auth/firebase_auth.dart';
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
  final SharedPreferences sharedPreferences = getIt.get<SharedPreferences>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${sharedPreferences.get("email")}"),
        Text("${sharedPreferences.get("id")}"),
        Center(
            child: ElevatedButton(
                onPressed: () {
                  context.read<UserCubit>().SignOut();
                },
                child: const Text("Sign Out"))),
      ],
    );
  }
}
