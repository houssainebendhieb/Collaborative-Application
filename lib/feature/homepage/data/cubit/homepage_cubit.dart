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

  Future<void> emitMyTeam() async {
    emit(HomepageMyTeamLoading());
    List<Map<String, dynamic>> listMyTeam = [];
    listMyTeam = await homepageRepoImp.getMyTeam();
    List<Map<String, dynamic>> listTeams = [];
    listTeams = await homepageRepoImp.getTeam();
    emit(HomepageMyTeamSucces(listTeam: listTeams, listMyTeam: listMyTeam));
  }

  Future<void> createTeam({required String teamName}) async {
    homepageRepoImp.createTeam(teamName: teamName);
  }

  Future<void> deleteDocument({required String idDocument}) async {
    homepageRepoImp.deleteDocument(idDocument: idDocument);
  }
}
