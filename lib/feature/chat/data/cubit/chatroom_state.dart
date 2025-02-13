part of 'chatroom_cubit.dart';

sealed class ChatroomState extends Equatable {
  const ChatroomState();

  @override
  List<Object> get props => [];
}

final class ChatroomInitial extends ChatroomState {}

final class ChatroomLoading extends ChatroomState {}

final class ChatroomSucces extends ChatroomState {
  final List<Map<String, dynamic>> listTeam;
  ChatroomSucces({required this.listTeam});
}
