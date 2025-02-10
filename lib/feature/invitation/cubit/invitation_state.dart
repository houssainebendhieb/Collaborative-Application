part of 'invitation_cubit.dart';

sealed class InvitationState extends Equatable {
  const InvitationState();
  @override
  List<Object> get props => [];
}

final class InvitationInitial extends InvitationState {}

final class InvitationRequestLoading extends InvitationState {}

final class InvitationLoading extends InvitationState {}

final class InvitationRequestSucces extends InvitationState {
  final List<Map<String, dynamic>> list;
  final List<Map<String, dynamic>> listPending;
  const InvitationRequestSucces(
      {required this.list, required this.listPending});
}

final class InvitationSucces extends InvitationState {
  final List<Map<String, dynamic>> list;
  const InvitationSucces({required this.list});
}
