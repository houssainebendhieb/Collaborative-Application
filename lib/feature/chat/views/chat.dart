import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/chat/data/cubit/chatroom_cubit.dart';
import 'package:google_docs_clone/feature/chat/data/logic/chat_repo.dart';
import 'package:google_docs_clone/feature/chat/views/chat_room.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatroomCubit, ChatroomState>(
        builder: (context, state) {
          if (state is ChatroomLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChatroomSucces) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: state.listTeam.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BlocProvider(
                                    create: (context) => ChatroomCubit(
                                        chatRepo: getIt.get<ChatRepo>()),
                                    child: ChatRoom(
                                      idTeam: state.listTeam[index]['id'] ??
                                          state.listTeam[index]['idteam'],
                                    ),
                                  );
                                }));
                              },
                              child: ListTile(
                                  title:
                                      Text("${state.listTeam[index]['name']}")),
                            );
                          })),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("not found"),
            );
          }
        },
      ),
    );
  }
}
