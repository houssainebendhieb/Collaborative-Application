import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_docs_clone/feature/document/logic/cubit/document_page_cubit.dart';

class DocumentPageScreen extends StatefulWidget {
  final idDocument;
  const DocumentPageScreen({super.key, required this.idDocument});

  @override
  State<DocumentPageScreen> createState() => _DocumentPageScreenState();
}

class _DocumentPageScreenState extends State<DocumentPageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentPageCubit, DocumentPageState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(state.title),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                QuillSimpleToolbar(
                    configurations: QuillSimpleToolbarConfigurations(
                        controller: state.quillController!)),
                Expanded(
                    child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                            controller: state.quillController!)))
              ],
            )),
      );
    });
  }
}
