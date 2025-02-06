import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/auth/data/cubit/user_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              context.read<UserCubit>().SignOut();
            },
            child: const Text("Sign Out")));
  }
}
