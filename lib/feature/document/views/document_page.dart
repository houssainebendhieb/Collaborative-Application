import 'package:flutter/material.dart';
import 'package:google_docs_clone/feature/document/logic/crdtcharacter.dart';

class CRDTEditorScreen extends StatefulWidget {
  final String documentId;
  final String userId;

  const CRDTEditorScreen(
      {super.key, required this.documentId, required this.userId});

  @override
  _CRDTEditorScreenState createState() => _CRDTEditorScreenState();
}

class _CRDTEditorScreenState extends State<CRDTEditorScreen> {
  final CRDTTextEditor crdtEditor;
  final TextEditingController textController = TextEditingController();

  _CRDTEditorScreenState() : crdtEditor = CRDTTextEditor(documentId: "doc1");

  @override
  void initState() {
    super.initState();
    crdtEditor.syncText().listen((chars) {
      setState(() {
        textController.text = chars.map((c) => c.value).join();
      });
    });
  }

  void _onTextChanged(String newText) {
    crdtEditor.addCharacter(newText, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRDT Text Editor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: textController,
          onChanged: _onTextChanged,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
