part of 'info_chatroom_cubit.dart';

sealed class InfoChatroomState extends Equatable {
  const InfoChatroomState();

  @override
  List<Object> get props => [];
}

final class InfoChatroomInitial extends InfoChatroomState {}

final class InfoChatroomSucces extends InfoChatroomState {
  final Map<String, dynamic> admin;
  final List<Map<String, dynamic>> listUserOnline;
  final List<Map<String, dynamic>> listUserOffline;
  const InfoChatroomSucces(
      {required this.listUserOffline,
      required this.listUserOnline,
      required this.admin});
}

final class InfoChatroomLoading extends InfoChatroomState {}
