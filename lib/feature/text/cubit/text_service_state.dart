part of 'text_service_cubit.dart';

@immutable
sealed class TextServiceState {}

final class TextServiceInitial extends TextServiceState {}

final class TextServiceLoading extends TextServiceState {}

// ignore: must_be_immutable
final class TextServiceSucces extends TextServiceState {
  final TextEditingController textController;
  final bool whoTyping;
  final String idTyping;
  bool? timeOut = false;
  final int index;
  TextServiceSucces(
      {required this.index,
      this.timeOut,
      required this.textController,
      required this.whoTyping,
      required this.idTyping});
}
