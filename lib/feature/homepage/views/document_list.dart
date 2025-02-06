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
        if (state is HomepageDocumentSucces) {
          return Expanded(
              child: ListView.builder(
            itemCount: state.listDocument.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${state.listDocument[index]['title']} "),
              );
            },
          ));
        } else if (state is HomepageLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomepageFailure) {
          return Center(
            child: Text("${state.errorMessage}"),
          );
        }
        return const Text("not found");
      },
    );
  }
}
