import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_docs_clone/feature/chat/data/logic/chat_repo.dart';

part 'chatroom_state.dart';

class ChatroomCubit extends Cubit<ChatroomState> {
  final ChatRepo chatRepo;
  ChatroomCubit({required this.chatRepo}) : super(ChatroomInitial());

  Future<void> emitTeam() async {
    emit(ChatroomLoading());
    List<Map<String, dynamic>> listTeams;
    listTeams = await chatRepo.getTeams();
    emit(ChatroomSucces(listTeam: listTeams));
  }
  Future<void> sendMessage(
      {required String idTeam,
      required String messageContent,
      required String idUser}) async {
    chatRepo.sendEmail(
        idTeam: idTeam, messageContent: messageContent, idUser: idUser);
  }
}