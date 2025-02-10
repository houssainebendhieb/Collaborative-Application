import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/invitation/cubit/invitation_cubit.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});
  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCubit, InvitationState>(
      builder: (context, state) {
        if (state is InvitationSucces) {
          if (state.list.isEmpty) {
            return const Center(
              child: Text("Empty , "),
            );
          }
          return Expanded(
              child: ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${state.list[index]['email']}"),
                      leading: IconButton(
                          onPressed: () {
                            context
                                .read<InvitationCubit>()
                                .deleteInvitation(id: state.list[index]['id']);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red)),
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
