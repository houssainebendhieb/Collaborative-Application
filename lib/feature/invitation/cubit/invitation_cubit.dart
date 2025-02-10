import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_docs_clone/feature/invitation/logic/repo/invitation_repo.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
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
    }
    emit(InvitationRequestSucces(list: list));
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

  Future<bool> sendInvitation({required String email}) async {
    bool res = await invitationRepoImp.sendInvitation(email: email);
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
}
