import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/invitation/cubit/invitation_cubit.dart';
import 'package:google_docs_clone/feature/invitation/logic/repo/invitation_repo.dart';
import 'package:google_docs_clone/feature/invitation/views/pending.dart';
import 'package:google_docs_clone/feature/invitation/views/request.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});
  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey key = GlobalKey<FormState>();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.sizeOf(context).height;
    var _width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("your team"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              height: _height * 0.05,
              width: _width,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: index == 0 ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Center(child: Text("Request")),
                    ),
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: index == 0 ? Colors.white : Colors.blue,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Center(child: Text("Pending")),
                    ),
                  )),
                ],
              ),
            ),
            index == 1
                ? BlocProvider(
                    create: (context) => InvitationCubit(
                        invitationRepoImp: getIt.get<InvitationRepo>())
                      ..emitAllPending(),
                    child: const PendingScreen(),
                  )
                : BlocProvider(
                    create: (context) => InvitationCubit(
                        invitationRepoImp: getIt.get<InvitationRepo>())
                      ..emitAllRequest(),
                    child: const RequestScreen(),
                  )
          ],
        ),
      ),
      floatingActionButton: index == 1
          ? ElevatedButton(
              onPressed: () {
                final BuildContext totoContext = context;
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: key,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "invalid email";
                                  }
                                },
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              bool res = await totoContext
                                  .read<InvitationCubit>()
                                  .sendInvitation(email: emailController.text);
                              if (res == false) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("no user with this email"),
                                  backgroundColor: Colors.blue,
                                ));
                              } else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("succes send invitation"),
                                  backgroundColor: Colors.blue,
                                ));
                              }
                            },
                            child: const Text('Send Invite'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    });
              },
              child: const Text("Add Invitation"))
          : null,
    );
  }
}
