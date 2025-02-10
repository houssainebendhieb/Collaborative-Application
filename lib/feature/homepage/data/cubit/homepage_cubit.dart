import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo.dart';
import 'package:meta/meta.dart';

part 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  HomepageCubit({required this.homepageRepoImp}) : super(HomepageInitial());
  final HomepageRepo homepageRepoImp;
  final TextEditingController titleController = TextEditingController();

  Future<void> addDocument({required String name}) async {
    homepageRepoImp.addDocument(name: name);
  }

  Future<void> emitDocument() async {
    emit(HomepageLoading());
    try {
      List<Map<String, dynamic>> listDocument =
          await homepageRepoImp.getDocument();
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

  Future<void> deleteDocument({required String idDocument}) async {
    homepageRepoImp.deleteDocument(idDocument: idDocument);
  }
}
