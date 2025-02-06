import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/auth/data/cubit/user_cubit.dart';
import 'package:google_docs_clone/feature/chat/views/chat.dart';
import 'package:google_docs_clone/feature/homepage/views/homepage.dart';
import 'package:google_docs_clone/feature/invitation/views/invitation.dart';
import 'package:google_docs_clone/feature/settings/views/settings.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int currentIndex = 0; // camel case
  // snake case chat_room.dart
  final List<Widget> listScreen =  [
  const   HomePageScreen(),
   const  ChatScreen(),
   const  InvitationScreen(),
    BlocProvider(
      create: (context) => UserCubit(),
      child:const  SettingScreen(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "homepage"),
          NavigationDestination(icon: Icon(Icons.chat), label: "chat"),
          NavigationDestination(
              icon: Icon(Icons.insert_invitation), label: "Invitation"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: listScreen[currentIndex],
    );
  }
}
