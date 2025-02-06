import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  HomepageCubit() : super(HomepageInitial());
  final _firebase = FirebaseFirestore.instance;
  Future<void> addDocument({required String name}) async {
    DocumentReference doc =
        await _firebase.collection("document").add({"title": name});
    await _firebase.collection("document").doc(doc.id).update({"id": doc.id});
  }

  Future<void> emitDocument() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("here ");
    print(prefs.getString("id"));
    emit(HomepageLoading());
    try {
      var res = await FirebaseFirestore.instance.collection("documents").get();
      List<Map<String, dynamic>> list = [];
      for (var a in res.docChanges) {
        list.add(a.doc.data()!);
      }
      emit(HomepageDocumentSucces(listDocument: list));
    } on FirebaseException catch (e) {
      emit(HomepageFailure(errorMessage: e.toString()));
    } catch (e) {
      emit(HomepageFailure(errorMessage: e.toString()));
    }
  }

  Future<void> emitTeam() async {
    emit(HomepageLoading());
    try {
      var res = await FirebaseFirestore.instance.collection("team").get();
      List<Map<String, dynamic>> list = [];
      for (var a in res.docChanges) {
        list.add(a.doc.data()!);
      }
      emit(HomepageDocumentSucces(listDocument: list));
    } on FirebaseException catch (e) {
      emit(HomepageFailure(errorMessage: e.toString()));
    } catch (e) {
      emit(HomepageFailure(errorMessage: e.toString()));
    }
  }

  Future<void>addDocument()async{
    
  }

}
