import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';
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
        appBar: AppBar(
          leading: const Icon(Icons.menu, color: Colors.blue),
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
                      create: (context) => HomepageCubit()..emitDocument(),
                      child: const DocumentList(),
                    )
                  : const TeamList()
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              //
              if (index == 0) {
              } else {}
            },
            child: const Icon(Icons.add)),
      ),
    );
  }
}
