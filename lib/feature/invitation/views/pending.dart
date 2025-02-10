import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/invitation/cubit/invitation_cubit.dart';

class PendingScreen extends StatefulWidget {
  final int index;
  const PendingScreen({required this.index, super.key});
  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCubit, InvitationState>(
      builder: (context, state) {
        print(state);
        if (state is InvitationRequestSucces) {
          if ((widget.index == 0 && state.list.isEmpty) ||
              (widget.index == 1 && state.listPending.isEmpty)) {
            return const Center(
              child: Text("Empty List ..."),
            );
          }
          print("pending");
          print(state.listPending);
          print("request");
          print(state.list);
          return Expanded(
              child: ListView.builder(
                  itemCount: widget.index == 0
                      ? state.list.length
                      : state.listPending.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: widget.index == 0
                          ? Text("${state.list[index]['email']}")
                          : Text("${state.listPending[index]['email']}"),
                      leading: widget.index == 1
                          ? IconButton(
                              onPressed: () {
                                context
                                    .read<InvitationCubit>()
                                    .deleteInvitation(
                                        id: state.list[index]['id']);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red))
                          : null,
                    );
                  }));
        } else if (state is InvitationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Text("not found");
      },
    );
  }
}
