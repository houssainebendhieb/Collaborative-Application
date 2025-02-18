import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/document/views/document_page.dart';

import 'package:google_docs_clone/feature/homepage/data/cubit/homepage_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';


class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.sizeOf(context).height;
    var _width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<HomepageCubit, HomepageState>(
      builder: (context, state) {
        if (state is HomepageDocumentSucces) {
          return Expanded(
              child: ListView.builder(
            itemCount: state.listDocument.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                      height: _height * 0.1,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.file_present_outlined),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const CRDTEditorScreen(
                                    documentId: "key",
                                    userId: "houssaine",
                                  );
                                }));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Column(children: [
                                  Text("${state.listDocument[index]['title']}"),
                                  const Text("last update ")
                                ]),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red[200]),
                              onPressed: () {
                                context.read<HomepageCubit>().deleteDocument(
                                    idDocument: state.listDocument[index]
                                        ['id']);
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      )),
                ),
              );

              // ListTile(
              //   title: Text("${state.listDocument[index]['title']} "),
              // );
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