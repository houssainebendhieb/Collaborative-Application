import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'document_page_state.dart';

class DocumentPageCubit extends Cubit<DocumentPageState> {
  DocumentPageCubit() : super(DocumentPageInitial());
  Future<void> emitController() async {
    FirebaseFirestore.instance
        .collection("document")
        .doc("houssaine")
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        emit(DocumentPageSucces(data: data));
        // var delta = Delta.fromJson(data['content'] ?? []);
        // quillController.document = Document.fromDelta(delta);
      }
    });
  }
  
}
