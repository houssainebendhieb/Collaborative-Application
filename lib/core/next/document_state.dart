import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentState extends Equatable {
  final String id;
  final QuillController? quillController;
  final bool isSavedRemotely;
  final String? errorMessage;

  const DocumentState({
    required this.id,
    this.quillController,
    this.isSavedRemotely = true,
    this.errorMessage,
  });

  DocumentState copyWith({
    QuillController? quillController,
    bool? isSavedRemotely,
    String? errorMessage,
  }) {
    return DocumentState(
      id: id,
      quillController: quillController ?? this.quillController,
      isSavedRemotely: isSavedRemotely ?? this.isSavedRemotely,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [id, quillController, isSavedRemotely, errorMessage];
}
