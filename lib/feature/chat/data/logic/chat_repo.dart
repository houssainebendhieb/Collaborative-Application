abstract class ChatRepo {
  Future<List<Map<String, dynamic>>> getTeams();
  Future<void> sendEmail(
      {required String idTeam,
      required String messageContent,
      required String idUser});
  Future<List<Map<String, dynamic>>> getOfflineUser({required String idTeam});
  Future<List<Map<String, dynamic>>> getOnlineUser({required String idTeam});
  Future<Map<String, dynamic>> getAdmin({required String idTeam});
}
