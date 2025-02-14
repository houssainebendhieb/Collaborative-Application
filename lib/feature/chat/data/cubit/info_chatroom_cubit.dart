import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:google_docs_clone/feature/chat/data/logic/chat_repo.dart';

part 'info_chatroom_state.dart';

class InfoChatroomCubit extends Cubit<InfoChatroomState> {
  InfoChatroomCubit() : super(InfoChatroomInitial());

  Future<void> emitAllUsersOfTeam({required String idTeam}) async {
    emit(InfoChatroomLoading());
    final ChatRepo chatRepo = getIt.get<ChatRepo>();
    List<Map<String, dynamic>> listUserOnline = [];

    List<Map<String, dynamic>> listUserOffline = [];

    Map<String, dynamic> admin = await chatRepo.getAdmin(idTeam: idTeam);

    listUserOnline = await chatRepo.getOnlineUser(idTeam: idTeam);
    listUserOffline = await chatRepo.getOfflineUser(idTeam: idTeam);
    emit(InfoChatroomSucces(
        listUserOffline: listUserOffline,
        listUserOnline: listUserOnline,
        admin: admin));
  }
}
