part of 'chatroom_cubit.dart';

sealed class ChatroomState extends Equatable {
  const ChatroomState();

  @override
  List<Object> get props => [];
}

final class ChatroomInitial extends ChatroomState {}
