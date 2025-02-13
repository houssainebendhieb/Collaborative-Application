abstract class ChatRepo {
  Future<List<Map<String, dynamic>>> getTeams();
  Future<void> sendEmail(
      {required String idTeam,
      required String messageContent,
      required String idUser});
}
