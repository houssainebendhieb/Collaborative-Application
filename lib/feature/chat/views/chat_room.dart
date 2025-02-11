import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/chat/data/cubit/chatroom_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  final String idTeam;
  const ChatRoom({super.key, required this.idTeam});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController messageController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Team name ...")),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Text("houssaine"),
            Text("houssaine"),
            Text("houssaine"),
            Text("houssaine"),
            Text("houssaine"),
            Text("houssaine"),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                  hintText: "Ecrire votre message....",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue))),
            )),
            IconButton(
                onPressed: () async {
                  print(messageController.text);
                  await context.read<ChatroomCubit>().sendMessage(
                      idTeam: widget.idTeam,
                      messageContent: messageController.text,
                      idUser: getIt.get<SharedPreferences>().getString("id")!);
                  messageController.clear();
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                  size: 25,
                )),
          ],
        ),
      ),
    );
  }
}
