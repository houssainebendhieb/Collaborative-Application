// import 'dart:async';
// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:flutter_quill/quill_delta.dart';
// import 'package:google_docs_clone/core/next/document_state.dart';
// import 'package:uuid/uuid.dart';

// class DocumentCubit extends Cubit<DocumentState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String documentId;
//   final _deviceId = const Uuid().v4();

//   StreamSubscription<DocumentSnapshot>? _realtimeListener;

//   DocumentCubit({required this.documentId})
//       : super(DocumentState(
//             id: documentId, quillController: QuillController.basic())) {
//     _loadDocument();
//     _setupRealtimeListener();
//   }

//   /// Load document from Firestore
//   Future<void> _loadDocument() async {
//     final docSnapshot =
//         await _firestore.collection('documents').doc(documentId).get();
//     print(docSnapshot);
//     late final Document quillDoc;
//     if (docSnapshot.exists && docSnapshot.data()?['content'] != null) {
//       quillDoc = Document.fromJson(jsonDecode(docSnapshot.data()!['content']));
//     } else {
//       quillDoc = Document()..insert(0, '');
//       await _firestore
//           .collection('documents')
//           .doc(documentId)
//           .update({'content': jsonEncode(quillDoc.toDelta().toJson())});
//     }

//     emit(DocumentState(
//         quillController: QuillController(
//           document: quillDoc,
//           selection: const TextSelection.collapsed(offset: 0),
//         ),
//         id: documentId));
//     state.quillController?.addListener(_onTextChanged);
//   }

//   /// Listen for real-time updates from Firestore
//   void _setupRealtimeListener() {
//     _realtimeListener =
//         _firestore.collection('documents').doc(documentId).snapshots().listen(
//       (docSnapshot) {
//         if (docSnapshot.exists &&
//             docSnapshot.data()?['deviceId'] != _deviceId) {
//           print("here");
//           final delta =
//               Delta.fromJson(jsonDecode(docSnapshot.data()!['content']));

//           state.quillController?.compose(
//             delta,
//             state.quillController!.selection,
//             ChangeSource.remote,
//           );
//           emit(DocumentState(
//               quillController: QuillController(
//                 document: state.quillController!.document,
//                 selection: const TextSelection.collapsed(offset: 0),
//               ),
//               id: documentId));
//         }
//       },
//     );
//   }

//   /// Handle local text changes and update Firestore
//   void _onTextChanged() {
//     final delta = state.quillController?.document.toDelta();
//     _firestore.collection('documents').doc(documentId).update({
//       'content': jsonEncode(delta?.toJson()),
//       'deviceId': _deviceId, // Prevents self-update loop
//     });
//   }

//   @override
//   Future<void> close() {
//     _realtimeListener?.cancel();
//     state.quillController?.removeListener(_onTextChanged);
//     return super.close();
//   }
// }
