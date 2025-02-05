import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:uuid/uuid.dart';

class DocPage extends StatefulWidget {
  final String documentId;

  const DocPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocPage> {
  late QuillController _quillController;
  StreamSubscription<DocumentSnapshot>? _documentListener;
  final String _deviceId = const Uuid().v4();
  var id = "0";
  Timer? autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController(
        document: Document()..insert(0, ""),
        selection: const TextSelection.collapsed(offset: 0));
    _setupDocument(); // Fetch and initialize the document
    _setupListeners();
    autoSaveTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _broadcastDeltaUpdate();
    });
  }

  Future<void> _setupDocument() async {
    try {
      final docPageData = await FirebaseFirestore.instance
          .collection('documents')
          .where("id", isEqualTo: widget.documentId)
          .get();

      late final Document quillDoc;
      if (!docPageData.docs.first.exists ||
          docPageData.docs.first.data()['content'] == null ||
          docPageData.docs.first.data()['content'] == "") {
        quillDoc = Document()..insert(0, '');
      } else {
        quillDoc = Document.fromDelta(
          Delta.fromJson(jsonDecode(docPageData.docs.first.data()['content'])),
        );
      }

      setState(() {
        id = docPageData.docs.first.id;
        _quillController = QuillController(
          document: quillDoc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });

      // _quillController.addListener(listener)
      // // Listen for local document changes
      // _quillController.changes.listen((event) {
      //   if (event.source == ChangeSource.local) {
      //     _broadcastDeltaUpdate(event.change);
      //     print(event);
      //   }
      // });
    } catch (e) {
      print("Error setting up document: $e");
    }
  }

  void _setupListeners() {
    _documentListener = FirebaseFirestore.instance
        .collection('documents')
        .doc(id)
        .snapshots()
        .listen((snapshot) {
      print("listen herer");
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final dId = data['deviceId'];

        final delta = Delta.fromJson(jsonDecode(data['content']));

        _quillController.compose(
          delta,
          _quillController.selection,
          ChangeSource.remote,
        );
      }
    });

    _quillController.document.changes.listen((event) {
      if (event.source == ChangeSource.local) {
        _broadcastDeltaUpdate();
      }
    });
  }

  Future<void> _broadcastDeltaUpdate() async {
    await FirebaseFirestore.instance.collection('documents').doc(id).update({
      'content': jsonEncode(_quillController.document.toDelta().toJson()),
      'deviceId': _deviceId,
    });
  }

  @override
  void dispose() {
    _documentListener?.cancel();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document Editor")),
      body: Column(
        children: [
          QuillSimpleToolbar(
              configurations: QuillSimpleToolbarConfigurations(
                  controller: _quillController)),
          Expanded(
            child: QuillEditor.basic(
              configurations:
                  QuillEditorConfigurations(controller: _quillController),
            ),
          ),
        ],
      ),
    );
  }
}
