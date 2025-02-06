import 'package:flutter/material.dart';

class TeamList extends StatefulWidget {
  const TeamList({super.key});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(title: Text("Team ${index}"));
            }));
  }
}
