import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/invitation/logic/repo/invitation_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvitationRepoImp extends InvitationRepo {
  final _firebase = getIt.get<FirebaseFirestore>();
  final SharedPreferences sharedPreferences = getIt.get<SharedPreferences>();

  @override
  Future<List<Map<String, dynamic>>> getAllInvitationRequest() async {
    List<Map<String, dynamic>> listInvitation = [];
    final String? id = sharedPreferences.getString("id");
    var res = await _firebase
        .collection("invitation")
        .where("receiver", isEqualTo: id)
        .where("status", isEqualTo: "pending")
        .get();
    for (var item in res.docChanges) {
      listInvitation.add(item.doc.data()!);
    }
    return listInvitation;
  }

  @override
  Future<bool> sendInvitation(
      {required String email, required String teamName}) async {
    var res = await _firebase
        .collection("user")
        .where("email", isEqualTo: email)
        .get();
    if (res.docChanges.isEmpty) {
      return false;
    }
    final String? id = sharedPreferences.getString("id");
    DocumentReference doc = await _firebase.collection("invitation").add({
      "sender": id,
      "receiver": res.docChanges.first.doc.data()!['id'],
      "status": "pending",
      "teamname": teamName,
      "emailsender": sharedPreferences.getString("email")
    });
    await _firebase.collection("invitation").doc(doc.id).update({"id": doc.id});
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllInvitationPending() async {
    final String? id = sharedPreferences.getString("id");
    List<Map<String, dynamic>> listInvitation = [];
    var res = await _firebase
        .collection("invitation")
        .where("sender", isEqualTo: id)
        .where("status", isEqualTo: "pending")
        .get();
    for (var item in res.docChanges) {
      listInvitation.add(item.doc.data()!);
    }
    return listInvitation;
  }

  @override
  Future<void> deleteInvitation({required String id}) async {
    await _firebase.collection("invitation").doc(id).delete();
  }

  @override
  Future<Map<String, dynamic>> getUser({required String id}) async {
    var res = await _firebase.collection('user').doc(id).get();
    return res.data()!;
  }

  @override
  Future<void> updateInvitaion(
      {required String id, required bool status}) async {
    DocumentReference doc = await _firebase.collection("invitation").doc(id);
    doc.update({"status": status});
    if (status) {
      final String? idd = sharedPreferences.getString('id');
      await _firebase
          .collection("userteam")
          .add({"iduser": idd, "idteam": doc.id});
    }
  }
}
