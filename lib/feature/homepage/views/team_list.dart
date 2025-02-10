import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo.dart';
import 'package:google_docs_clone/feature/homepage/views/myteam.dart';
import 'package:google_docs_clone/feature/homepage/views/teams.dart';

class TeamList extends StatefulWidget {
  const TeamList({super.key});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.sizeOf(context).height;
    var _width = MediaQuery.sizeOf(context).width;
    return Expanded(
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
                        color: index == 0 ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: const Center(child: Text("My Team")),
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
                        color: index == 0 ? Colors.white : Colors.green,
                        borderRadius: BorderRadius.circular(25)),
                    child: const Center(child: Text("Teams")),
                  ),
                )),
              ],
            ),
          ),
          index == 0
              ? BlocProvider(
                  create: (context) =>
                      HomepageCubit(homepageRepoImp: getIt.get<HomepageRepo>())
                        ..emitMyTeam(),
                  child: const MyteamScreen(),
                )
              : TeamsScreen()
        ],
      ),
    );
  }
}
