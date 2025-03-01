import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/chat/data/cubit/chatroom_cubit.dart';
import 'package:google_docs_clone/feature/chat/data/logic/chat_repo.dart';
import 'package:google_docs_clone/feature/chat/views/chat_room.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Teams", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        elevation: 4,
      ),
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
                                  teamName: state.listTeam[index]['name'],
                                  idTeam: state.listTeam[index]['id'] ??
                                      state.listTeam[index]['idteam'],
                                ),
                              );
                            }));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade500,
                                  Colors.blue.shade300
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade200,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.group, color: Colors.blue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "${state.listTeam[index]['name']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("new meeting"))
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("No teams found",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }
        },
      ),
    );
  }

  void joinMeeting() async {
    try {
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.jit.si",
        room: "jitsiIsAwesomeWithFlutter",
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "subject": "Jitsi with Flutter",
        },
        featureFlags: {"unsaferoomwarning.enabled": false},
        userInfo: JitsiMeetUserInfo(
            displayName: "Flutter user", email: "user@example.com"),
      );

      //await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("Error: $error");
    }
  }
}
