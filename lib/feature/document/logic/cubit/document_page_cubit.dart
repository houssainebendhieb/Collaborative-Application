import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:meta/meta.dart';

part 'document_page_state.dart';

class DocumentPageCubit extends Cubit<DocumentPageState> {
  DocumentPageCubit({required this.id})
      : super(DocumentPageState(
          title: "",
          quillController: QuillController(
              selection: const TextSelection.collapsed(offset: 0),
              document: Document()..insert(0, "data")),
        )) {
    emitController(idDocument: id);
    setupRealtimeListener();
  }
  final String id;
  final _firestore = getIt.get<FirebaseFirestore>();
  final QuillController quillController = QuillController.basic();
  StreamSubscription<DocumentSnapshot>? realtimeListener;
  var title = "";
  Future<void> emitController({required String idDocument}) async {
    final docSnapshot =
        await _firestore.collection('documents').doc(idDocument).get();
    print(docSnapshot);
    title = docSnapshot.data()!['title'];
    late final Document quillDoc;
    if (docSnapshot.exists && docSnapshot.data()?['content'] != null) {
      quillDoc = Document.fromJson(jsonDecode(docSnapshot.data()!['content']));
    } else {
      quillDoc = Document()..insert(0, '');
      await _firestore
          .collection('documents')
          .doc(idDocument)
          .update({'content': jsonEncode(quillDoc.toDelta().toJson())});
    }

    emit(DocumentPageState(
        title: title,
        quillController: QuillController(
            document: quillDoc,
            selection: const TextSelection.collapsed(offset: 0))));
    state.quillController?.addListener(onTextChanged);
  }

  void onTextChanged() {
    final delta = state.quillController?.document.toDelta();
    _firestore.collection('documents').doc(id).update({
      'content': jsonEncode(delta?.toJson()),
      'deviceId': "_deviceId", // Prevents self-update loop
    });
  }

  /// Listen for real-time updates from Firestore
  void setupRealtimeListener() {
    realtimeListener =
        _firestore.collection('documents').doc(id).snapshots().listen(
      (docSnapshot) {
        if (docSnapshot.exists) {
          print("here");
          final delta =
              Delta.fromJson(jsonDecode(docSnapshot.data()!['content']));

          state.quillController?.compose(
            delta,
            state.quillController!.selection,
            ChangeSource.remote,
          );
          emit(DocumentPageState(
              quillController: QuillController(
                document: state.quillController!.document,
                selection: const TextSelection.collapsed(offset: 0),
              ),
              title: title));
        }
      },
    );
  }
}
