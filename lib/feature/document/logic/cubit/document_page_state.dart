part of 'document_page_cubit.dart';

@immutable
sealed class DocumentPageState {}

final class DocumentPageInitial extends DocumentPageState {}

final class DocumentPageSucces extends DocumentPageState {
  final Map<String, dynamic> data;
  DocumentPageSucces({required this.data});
}

final class DocumentPageLoading extends DocumentPageState {}
