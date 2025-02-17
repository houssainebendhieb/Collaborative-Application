import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:google_docs_clone/feature/document/logic/cubit/document_page_cubit.dart';

class DocumentEditorPage extends StatefulWidget {
  final String docId;
  final String currentUserId;
  final String userName;
  final String userColor;

  const DocumentEditorPage({
    required this.docId,
    required this.currentUserId,
    required this.userName,
    required this.userColor,
  });

  @override
  State<DocumentEditorPage> createState() => _DocumentEditorPageState();
}

<<<<<<< Updated upstream
class _DocumentPageScreenState extends State<DocumentPageScreen> {
  @override
  void initState() {
    super.initState();
  }

=======
class _DocumentEditorPageState extends State<DocumentEditorPage> {
>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    print(widget.docId);
    return BlocProvider(
      create: (_) => DocumentCubit(),
      child: Scaffold(
        appBar: AppBar(
<<<<<<< Updated upstream
          title: Text(state.title),
=======
          title: const Text("Real-Time Document Editor"),
>>>>>>> Stashed changes
        ),
        body: BlocBuilder<DocumentCubit, DocumentState>(
          builder: (context, state) {
            return Column(
              children: [
                // Quill Editor to display and edit content
                QuillSimpleToolbar(
                    configurations: QuillSimpleToolbarConfigurations(
                        controller: state.controller)),
                Expanded(
                  child: QuillEditor.basic(
                    configurations: QuillEditorConfigurations(
                        autoFocus: true, controller: state.controller),
                  ),
                ),
                // Display other users' cursor positions
                _buildRemoteCursors(state.usersTyping),
              ],
            );
          },
        ),
      ),
    );
  }

  // Build remote users' cursors by listening to changes in Firestore
  Widget _buildRemoteCursors(Map<String, dynamic> usersTyping) {
    List<Widget> remoteCursors = [];

    usersTyping.forEach((userId, cursorData) {
      if (userId != widget.currentUserId) {
        remoteCursors.add(Positioned(
          top: _getCursorPosition(cursorData['index']),
          left: 5, // Adjust this based on your layout
          child: Container(
            width: 2,
            height: 20,
            color: Color(int.parse(cursorData['color'])),
          ),
        ));
      }
    });

    return Column(
      children: remoteCursors,
    );
  }

  // Convert the cursor index to an actual position in the editor
  double _getCursorPosition(int index) {
    return index * 20.0; // Adjust based on the font size or line height
  }

  // Listen to Firestore for document and cursor changes
  void listenForDocumentChanges(String docId, BuildContext context) {
    FirebaseFirestore.instance
        .collection("documents")
        .doc(docId)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final newDelta = Delta.fromJson(data?['content']);
        context
            .read<DocumentCubit>()
            .setUsersTyping(data?['usersTyping'] ?? {});
        context.read<DocumentCubit>().updateText(docId, newDelta);
      }
    });
  }

  void listenForCursorChanges(String docId, BuildContext context) {
    FirebaseFirestore.instance
        .collection("documents")
        .doc(docId)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final usersTyping = docSnapshot.data()?['usersTyping'] ?? {};
        context.read<DocumentCubit>().setUsersTyping(usersTyping);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Start listening for document and cursor changes in Firestore
    listenForDocumentChanges(widget.docId, context);
    listenForCursorChanges(widget.docId, context);
  }
}
