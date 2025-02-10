abstract class InvitationRepo {
  Future<List<Map<String, dynamic>>> getAllInvitationRequest();
  Future<List<Map<String, dynamic>>> getAllInvitationPending();
  Future<bool> sendInvitation({required String email});
  Future<void> deleteInvitation({required String id});
  Future<Map<String, dynamic>> getUser({required String id});
  Future<void> updateInvitaion({required String id, required bool status});
}
