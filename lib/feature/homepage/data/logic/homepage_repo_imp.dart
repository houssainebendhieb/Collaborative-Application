import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageRepoImp extends HomepageRepo {
  final _firebase = getIt.get<FirebaseFirestore>();
  final SharedPreferences sharedPreferences = getIt.get<SharedPreferences>();
  @override
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

  @override
  Future<List<Map<String, dynamic>>> getDocument() async {
    String? id = sharedPreferences.getString("id");
    var res = await _firebase
        .collection("documentuser")
        .where("idUser", isEqualTo: id)
        .get();
    List<String> list = [];
    List<Map<String, dynamic>> listDocument = [];
    for (var a in res.docChanges) {
      list.add(a.doc.data()!['idDocument']);
    }

    for (var i in list) {
      var res = await _firebase.collection("documents").doc(i).get();
      listDocument.add(res.data()!);
    }
    return listDocument;
  }

  @override
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

  Future<void> deleteDocument({required String idDocument}) async {
    final idUser = getIt.get<SharedPreferences>().getString("id");
    var res = await _firebase
        .collection("documentuser")
        .where("idDocument", isEqualTo: idDocument)
        .where("idUser", isEqualTo: idUser)
        .get();
    var doc = res.docChanges.first.doc;
    await _firebase.collection("documentuser").doc(doc.id).delete();
    await _firebase.collection("documents").doc(idDocument).delete();
  }

  @override
  Future<void> createTeam({required String teamName}) async {
    final String? id = sharedPreferences.getString("id");
    DocumentReference doc = await _firebase
        .collection("team")
        .add({"name": teamName, "idOwner": id});
    await _firebase.collection("team").doc(doc.id).update({"id": doc.id});
  }

  @override
  Future<List<Map<String, dynamic>>> getTeam() async {
    final String? id = sharedPreferences.getString("id");
    List<Map<String, dynamic>> listDocument = [];
    var res = await _firebase
        .collection("userteam")
        .where("iduser", isEqualTo: id)
        .get();
    for (var item in res.docChanges) {
      listDocument.add(item.doc.data()!);
    }
    for (var item in listDocument) {
      var team = await getTeamById(id: item['idteam']);
      item['name'] = team['name'];
    }
    return listDocument;
  }

  @override
  Future<Map<String, dynamic>> getTeamById({required String id}) async {
    var doc = await _firebase.collection("team").doc(id).get();
    return doc.data()!;
  }
}
