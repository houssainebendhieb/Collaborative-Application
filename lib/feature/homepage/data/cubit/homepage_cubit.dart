import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  HomepageCubit() : super(HomepageInitial());
  final _firebase = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  Future<void> addDocument({required String name}) async {
    DocumentReference doc =
        await _firebase.collection("documents").add({"title": name});
    await _firebase.collection("documents").doc(doc.id).update({"id": doc.id});
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? id = sharedPreferences.getString("id");
    await _firebase
        .collection("documentuser")
        .add({"idDocument": doc.id, "idUser": id});
  }

  Future<void> emitDocument() async {
    emit(HomepageLoading());
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? id = sharedPreferences.getString("id");
      var res = await FirebaseFirestore.instance
          .collection("documentuser")
          .where("idUser", isEqualTo: id)
          .get();
      List<String> list = [];
      List<Map<String, dynamic>> listDocument = [];
      for (var a in res.docChanges) {
        list.add(a.doc.data()!['idDocument']);
      }
      print("ehre");
      print(list);
      for (var i in list) {
        var res = await _firebase.collection("documents").doc(i).get();
        listDocument.add(res.data()!);
      }
      print("");
      print(listDocument);
      emit(HomepageDocumentSucces(listDocument: listDocument));
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

  Future<void> showDialog(BuildContext context) async {
    /* showDialog(
      context: context,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Title"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Type your title here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String title = _titleController.text;
                print("Entered Title: $title"); // Handle the title
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );*/
  }
}
