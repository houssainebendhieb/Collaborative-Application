abstract class HomepageRepo {
  Future<void> addDocument({required String name});
  Future<List<Map<String, dynamic>>> getDocument();
  Future<List<Map<String, dynamic>>> getTeam();
  Future<List<Map<String, dynamic>>> getMyTeam();
  Future<void> deleteDocument({required String idDocument});
  Future<void> createTeam({required String teamName});
}
