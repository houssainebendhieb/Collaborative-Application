import 'package:flutter_quill/flutter_quill.dart' as quill;

class DocumentState {
  final quill.QuillController controller;
  final Map<String, dynamic> usersTyping;

  DocumentState({
    required this.controller,
    required this.usersTyping,
  });

  // Copy constructor to clone and update state
  DocumentState copyWith({
    quill.QuillController? controller,
    Map<String, dynamic>? usersTyping,
  }) {
    return DocumentState(
      controller: controller ?? this.controller,
      usersTyping: usersTyping ?? this.usersTyping,
    );
  }
}
