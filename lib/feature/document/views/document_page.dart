import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_docs_clone/feature/document/logic/cubit/document_page_cubit.dart';

class DocumentPageScreen extends StatefulWidget {
  const DocumentPageScreen({super.key});

  @override
  State<DocumentPageScreen> createState() => _DocumentPageScreenState();
}

class _DocumentPageScreenState extends State<DocumentPageScreen> {
  final QuillController quillController = QuillController(
      document: Document()..insert(0, ""),
      selection: const TextSelection(baseOffset: 0, extentOffset: 0));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              QuillSimpleToolbar(
                  configurations: QuillSimpleToolbarConfigurations(
                      controller: quillController)),
              Expanded(
                  child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                          controller: quillController)))
            ],
          )),
    );
  }
}
