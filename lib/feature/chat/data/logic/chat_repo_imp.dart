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
    await _firebase
        .collection("message")
        .add({"idteam": idTeam, "message": messageContent, "iduser": idUser});
  }
}
