import 'package:bloc/bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/quill_delta.dart';


<<<<<<< Updated upstream

class DocumentPageCubit extends Cubit<DocumentPageState> {
  DocumentPageCubit({required this.id})
      : super(DocumentPageState(
          title: "",
          quillController: QuillController(
              selection: const TextSelection.collapsed(offset: 0),
              document: Document()..insert(0, "data")),
        )) {
    emitController(idDocument: id);
    
  }
  final String id;
  final _firestore = getIt.get<FirebaseFirestore>();
  final QuillController quillController = QuillController.basic();
  StreamSubscription<DocumentSnapshot>? realtimeListener;
  var title = "";
  Future<void> emitController({required String idDocument}) async {
    final docSnapshot =
        await _firestore.collection('documents').doc(idDocument).get();
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
=======
// Document State to hold document and users' typing data
class DocumentState {
  final QuillController controller;
  final Map<String, dynamic> usersTyping;
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
=======

  // Update users' typing positions from Firestore
  void setUsersTyping(Map<String, dynamic> usersTyping) {
    emit(DocumentState(controller: state.controller, usersTyping: usersTyping));
  }
>>>>>>> Stashed changes
}