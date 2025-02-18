import 'package:bloc/bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/quill_delta.dart';


// Document State to hold document and users' typing data
class DocumentState {
  final QuillController controller;
  final Map<String, dynamic> usersTyping;

  DocumentState({required this.controller, required this.usersTyping});
}

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit()
      : super(DocumentState(controller: QuillController.basic(), usersTyping: {}));

  // Set the QuillController
  void setController(QuillController controller) {
    emit(DocumentState(controller: controller, usersTyping: state.usersTyping));
  }

  // Update document content with the given Quill Delta and sync with Firestore
  void updateText(String docId, Delta delta) {
    emit(DocumentState(
        controller: state.controller..document.compose(delta, ChangeSource.remote),
        usersTyping: state.usersTyping));

    // Update Firestore with the new document content
    FirebaseFirestore.instance.collection("documents").doc(docId).update({
      "content": state.controller.document.toDelta().toJson(),
    });
  }

  // Update cursor position of a user and sync with Firestore
  void updateCursor(String docId, String userId, int index, int length, String color, String name) {
    final updatedUsersTyping = Map<String, dynamic>.from(state.usersTyping);
    updatedUsersTyping[userId] = {
      "index": index,
      "length": length,
      "color": color,
      "name": name,
    };

    emit(DocumentState(controller: state.controller, usersTyping: updatedUsersTyping));

    // Update Firestore with the new cursor positions
    FirebaseFirestore.instance.collection("documents").doc(docId).update({
      "usersTyping": updatedUsersTyping,
    });
  }

  // Update users' typing positions from Firestore
  void setUsersTyping(Map<String, dynamic> usersTyping) {
    emit(DocumentState(controller: state.controller, usersTyping: usersTyping));
  }
}