import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/chat/data/cubit/chatroom_cubit.dart';
import 'package:google_docs_clone/feature/chat/data/cubit/info_chatroom_cubit.dart';
import 'package:google_docs_clone/feature/chat/views/widget/info_screen.dart';
import 'package:google_docs_clone/feature/chat/views/widget/message_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  final String idTeam;
  final String teamName;
  const ChatRoom({super.key, required this.teamName, required this.idTeam});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String id = getIt.get<SharedPreferences>().getString("id") ?? " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) => InfoChatroomCubit()
                    ..emitAllUsersOfTeam(idTeam: widget.idTeam),
                  child: InfoScreen(
                    idTeam: widget.idTeam,
                  ),
                );
              }));
            },
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        title:
            Text(widget.teamName, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("message")
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return const Center(child: Text("Empty ..."));
                }
                var listMessage = [];
                for (var item in snapshot.data!.docs) {
                  if (item.data()['idteam'] == widget.idTeam) {
                    listMessage.add(item.data());
                  }
                }
                if (listMessage.isEmpty) {
                  return const Center(child: Text("No messages yet..."));
                }
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: listMessage.length,
                  itemBuilder: (context, index) {
                    return messageBubble(
                      message: listMessage[index]["message"] as String,
                      isMe: listMessage[index]['iduser'] == id,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Write a message...",
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          _scrollController.jumpTo(
                              _scrollController.position.minScrollExtent);
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.blue.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if (messageController.text.trim().isEmpty) return;
                        await context.read<ChatroomCubit>().sendMessage(
                              idTeam: widget.idTeam,
                              messageContent: messageController.text.trim(),
                              idUser: id,
                            );
                        messageController.clear();
                        Future.delayed(Duration(milliseconds: 300), () {
                          _scrollController.jumpTo(
                              _scrollController.position.minScrollExtent);
                        });
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
