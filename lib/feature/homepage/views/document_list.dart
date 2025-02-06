import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomepageCubit, HomepageState>(
      builder: (context, state) {
        return Expanded(
            child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ListTile(
              title: Text("houssaine "),
            );
          },
        ));
      },
    );
  }
}
