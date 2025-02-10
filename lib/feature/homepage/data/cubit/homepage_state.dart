part of 'homepage_cubit.dart';

@immutable
sealed class HomepageState {}

final class HomepageInitial extends HomepageState {}

final class HomepageTeamLoading extends HomepageState {}

final class HomepageDocumentSucces extends HomepageState {
  HomepageDocumentSucces({required this.listDocument});
  final List<Map<String, dynamic>> listDocument;
}

final class HomepageMyTeamSucces extends HomepageState {
  HomepageMyTeamSucces({required this.listTeam, required this.listMyTeam});
  final List<Map<String, dynamic>> listTeam;
  final List<Map<String, dynamic>> listMyTeam;
}

final class HomepageLoading extends HomepageState {}

final class HomepageMyTeamLoading extends HomepageState {}

final class HomepageFailure extends HomepageState {
  final String errorMessage;
  HomepageFailure({required this.errorMessage});
}
