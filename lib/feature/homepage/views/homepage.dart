import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo.dart';
import 'package:google_docs_clone/feature/homepage/views/document_list.dart';
import 'package:google_docs_clone/feature/homepage/views/team_list.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.sizeOf(context).height;
    var _width = MediaQuery.sizeOf(context).width;
    return SafeArea(
        child: Scaffold(
      drawer: const Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            children: [
              Icon(
                Icons.person,
                size: 100,
              ),
              Text("Settings"),
              Text("Theme"),
              Text("Profile"),
              Text("..."),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "HomePage",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      child: const Center(child: Text("Documents")),
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
                      child: const Center(child: Text("Team")),
                    ),
                  )),
                ],
              ),
            ),
            index == 0
                ? BlocProvider(
                    create: (context) => HomepageCubit(
                        homepageRepoImp: getIt.get<HomepageRepo>())
                      ..emitDocument(),
                    child: const DocumentList(),
                  )
                : BlocProvider(
                    create: (context) => HomepageCubit(
                        homepageRepoImp: getIt.get<HomepageRepo>())
                      ..emitMyTeam(),
                    child: const TeamList(),
                  )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            final rootContext = context;
            if (index == 0) {
              final TextEditingController titleController =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Enter Title"),
                    content: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: "Type your title here"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          String title = titleController.text;
                          rootContext
                              .read<HomepageCubit>()
                              .addDocument(name: title);
                          Navigator.pop(context);
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );
            } else {
              final TextEditingController titleController =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Enter Title"),
                    content: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: "Type your title here"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          String title = titleController.text;
                          rootContext
                              .read<HomepageCubit>()
                              .createTeam(teamName: title);

                          Navigator.pop(context);
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Icon(Icons.add)),
    ));
  }
}
