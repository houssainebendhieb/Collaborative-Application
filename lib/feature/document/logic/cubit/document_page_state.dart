part of 'document_page_cubit.dart';

@immutable
final class DocumentPageState extends Equatable {
  final QuillController? quillController;
  final String title;
  DocumentPageState({required this.quillController, required this.title});

  @override
  List<Object?> get props => [quillController, title];
}
