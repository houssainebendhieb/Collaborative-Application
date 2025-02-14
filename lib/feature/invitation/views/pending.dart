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
        if (state is InvitationRequestSucces) {
          if ((widget.index == 0 && state.list.isEmpty) ||
              (widget.index == 1 && state.listPending.isEmpty)) {
            return const Center(
              child: Text("Empty List ..."),
            );
          }

          return Expanded(
              child: ListView.builder(
                  itemCount: widget.index == 0
                      ? state.list.length
                      : state.listPending.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.index == 0
                              ? Text(
                                  "${state.list[index]['emailsender']}",
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  "${state.listPending[index]['email']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                          widget.index == 0
                              ? Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<InvitationCubit>()
                                                .changeStatus(
                                                    id: state.list[index]['id'],
                                                    status: true);
                                          },
                                          child: const Text("Accept"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: GestureDetector(
                                        onTap: () {
                                          context
                                              .read<InvitationCubit>()
                                              .changeStatus(
                                                  id: state.list[index]['id'],
                                                  status: false);
                                        },
                                        child: const Text("Refuse"),
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
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
