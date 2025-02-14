import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/chat/data/logic/chat_repo.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepoImp extends ChatRepo {
  final _firebase = getIt.get<FirebaseFirestore>();
  final SharedPreferences sharedPreferences = getIt.get<SharedPreferences>();
  final HomepageRepo homepageRepo = getIt.get<HomepageRepo>();
  @override
  Future<List<Map<String, dynamic>>> getTeams() async {
    List<Map<String, dynamic>> listMyTeams = await homepageRepo.getMyTeam();
    List<Map<String, dynamic>> listTeam = await homepageRepo.getTeam();
    for (var team in listTeam) {
      listMyTeams.add(team);
    }
    return listMyTeams;
  }

  @override
  Future<void> sendEmail(
      {required String idTeam,
      required String messageContent,
      required String idUser}) async {
    await _firebase.collection("message").add({
      "idteam": idTeam,
      "message": messageContent,
      "iduser": idUser,
      "date": DateTime.now()
    });
  }

  Future<Map<String, dynamic>> getUser(
      {required String userId, bool? status}) async {
    var doc = await _firebase.collection("user").doc(userId).get();
    if (doc.exists) {
      if (status != null && doc.data()!['status'] == status) {
        return doc.data()!;
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> getAdmin({required String idTeam}) async {
    var res = await _firebase.collection("team").doc(idTeam).get();
    print(res.data());
    var aux = res.data() as Map<String, dynamic>;
    print(aux);
    return await getUser(userId: aux['idOwner']);
  }

  Future<List<Map<String, dynamic>>> getOnlineUser(
      {required String idTeam}) async {
    List<Map<String, dynamic>> listOnlineUser = [];
    QuerySnapshot res = await _firebase
        .collection("userteam")
        .where("idteam", isEqualTo: idTeam)
        .get();
    for (DocumentChange item in res.docChanges) {
      var aux = item.doc.data() as Map<String, dynamic>;
      var doc = await getUser(userId: aux['iduser'] ?? " ", status: true);
      if (doc != {}) {
        listOnlineUser.add(doc);
      }
    }

    return listOnlineUser;
  }

  Future<List<Map<String, dynamic>>> getOfflineUser(
      {required String idTeam}) async {
    List<Map<String, dynamic>> listOnlineUser = [];
    QuerySnapshot res = await _firebase
        .collection("userteam")
        .where("idteam", isEqualTo: idTeam)
        .get();
    for (var item in res.docChanges) {
      var doc = await getUser(userId: item.doc.id, status: false);
      if (doc != {}) {
        listOnlineUser.add(doc);
      }
    }

    return listOnlineUser;
  }
}
