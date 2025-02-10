import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';

class MyteamScreen extends StatefulWidget {
  const MyteamScreen({super.key});

  @override
  State<MyteamScreen> createState() => _MyteamScreenState();
}

class _MyteamScreenState extends State<MyteamScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageCubit, HomepageState>(
      builder: (context, state) {
        if (state is HomepageMyTeamSucces) {
          if (state.listTeam.isEmpty) {
            return const Center(
              child: Text("Empty"),
            );
          }
          return Expanded(
              child: ListView.builder(
                  itemCount: state.listTeam.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${state.listTeam[index]['name']}"),
                    );
                  }));
        } else if (state is HomepageMyTeamLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Text("not found");
      },
    );
  }
}
