import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/invitation/cubit/invitation_cubit.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCubit, InvitationState>(
      builder: (context, state) {
        if (state is InvitationRequestSucces) {
          if (state.list.isEmpty) {
            return const Center(
              child: Text("Empty , "),
            );
          }
          return Expanded(
              child: ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${state.list[index]['email']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(25)),
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
                                    borderRadius: BorderRadius.circular(25)),
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
                        ],
                      ),
                    );
                  }));
        } else if (state is InvitationRequestLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Text("not found");
      },
    );
  }
}
