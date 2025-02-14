import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/chat/data/cubit/info_chatroom_cubit.dart';

class InfoScreen extends StatefulWidget {
  final String idTeam;
  const InfoScreen({super.key, required this.idTeam});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Info")),
      body: BlocBuilder<InfoChatroomCubit, InfoChatroomState>(
        builder: (context, state) {
          if (state is InfoChatroomLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is InfoChatroomSucces) {
            return Column(
              children: [
                const Text("Admin"),
                Text(state.admin['username']),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Active Member",
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: ListView.builder(
                      itemCount: state.listUserOnline.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              state.listUserOnline[index]['username'] ?? " "),
                        );
                      }),
                ),
                Text("Offline user"),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: ListView.builder(
                      itemCount: state.listUserOnline.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              state.listUserOffline[index]['username'] ?? " "),
                        );
                      }),
                ),
              ],
            );
          }
          return const Text("not found");
        },
      ),
    );
  }
}
