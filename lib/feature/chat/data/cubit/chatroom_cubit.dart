import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chatroom_state.dart';

class ChatroomCubit extends Cubit<ChatroomState> {
  ChatroomCubit() : super(ChatroomInitial());
}
