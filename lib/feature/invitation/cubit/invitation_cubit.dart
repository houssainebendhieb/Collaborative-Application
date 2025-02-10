import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/invitation/logic/repo/invitation_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final _firebase = getIt.get<FirebaseFirestore>();
  final SharedPreferences sharedPreferences = getIt.get<SharedPreferences>();
  final InvitationRepo invitationRepoImp;
  InvitationCubit({required this.invitationRepoImp})
      : super(InvitationInitial());

  void emitAllRequest() async {
    emit(InvitationRequestLoading());
    late List<Map<String, dynamic>> list;
    list = await invitationRepoImp.getAllInvitationRequest();
    for (var item in list) {
      var user = await getUser(id: item['receiver']);
      item['email'] = user['email'];
     // item['emailsender'] = sharedPreferences.getString("email");
    }
    late List<Map<String, dynamic>> listPending;
    listPending = await invitationRepoImp.getAllInvitationPending();
    for (var item in listPending) {
      var user = await getUser(id: item['receiver']);
      item['email'] = user['email'];
    }
    emit(InvitationRequestSucces(list: list,listPending: listPending));
  }

  void emitAllPending() async {
    emit(InvitationLoading());
    late List<Map<String, dynamic>> list;
    list = await invitationRepoImp.getAllInvitationPending();
    for (var item in list) {
      var user = await getUser(id: item['receiver']);
      item['email'] = user['email'];
    }
    emit(InvitationSucces(list: list));
  }

  Future<bool> sendInvitation(
      {required String email, required String teamName}) async {
    bool res = await invitationRepoImp.sendInvitation(
        email: email, teamName: teamName);
    print(res);
    return res;
  }

  Future<void> deleteInvitation({required String id}) async {
    await invitationRepoImp.deleteInvitation(id: id);
  }

  Future<Map<String, dynamic>> getUser({required String id}) async {
    return await invitationRepoImp.getUser(id: id);
  }

  Future<void> changeStatus({required String id, required bool status}) async {
    invitationRepoImp.updateInvitaion(id: id, status: status);
  }

  Future<List<Map<String, dynamic>>> getMyTeam() async {
    final String? id = sharedPreferences.getString("id");
    var res = await _firebase
        .collection("team")
        .where("idOwner", isEqualTo: id)
        .get();
    List<Map<String, dynamic>> list = [];
    for (var a in res.docChanges) {
      list.add(a.doc.data()!);
    }
    return list;
  }
}
