import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';

class MyteamScreen extends StatefulWidget {
  final int index;
  const MyteamScreen({required this.index, super.key});

  @override
  State<MyteamScreen> createState() => _MyteamScreenState();
}

class _MyteamScreenState extends State<MyteamScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageCubit, HomepageState>(
      builder: (context, state) {
        if (state is HomepageMyTeamLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomepageMyTeamSucces) {
          return Expanded(
              child: ListView.builder(
                  itemCount: widget.index == 0
                      ? state.listMyTeam.length
                      : state.listTeam.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: widget.index == 0
                          ? Text(" ${state.listMyTeam[index]['name']}")
                          : Text(" ${state.listTeam[index]['name']}"),
                    );
                  }));
        }
        return const Text("not found");
      },
    );
  }
}
