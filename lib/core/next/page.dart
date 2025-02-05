import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_docs_clone/core/next/document_cubit.dart';
import 'package:google_docs_clone/core/next/document_state.dart';

class PageScreen extends StatelessWidget {
  final String documentId;

  const PageScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return DocumentView(documentId: documentId);
  }
}

class DocumentView extends StatefulWidget {
  final documentId;
  DocumentView({required this.documentId});
  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Document Editor")),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('documents')
                .doc(widget.documentId)
                .snapshots(),
            builder: (context, snapshot) {
              QuillController? quillController;
              final delta = snapshot.data!.data()!['content'];
              quillController!.compose(
                  delta,
                  const TextSelection.collapsed(offset: 0),
                  ChangeSource.remote);
              return Column(
                children: [
                  QuillSimpleToolbar(
                      configurations: QuillSimpleToolbarConfigurations(
                          controller: quillController)),
                  Expanded(
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        controller: quillController,
                        autoFocus: true,
                        expands: true,
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
